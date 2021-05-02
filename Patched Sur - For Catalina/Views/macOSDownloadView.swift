//
//  macOSDownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/16/21.
//

import VeliaUI
import Files

struct macOSDownloadView: View {
    @State var errorX = ""
    @State var downloadSize = 55357820
    @State var downloadProgress = CGFloat(0)
    @State var progressHuman = 0 as CGFloat
    @State var currentSize = 10
    let timer = Timer.publish(every: 0.50, on: .current, in: .common).autoconnect()
    @Binding var p: PSPage
    @Binding var installInfo: InstallAssistant?
    @Binding var onExit: () -> (BackMode)
    @State var alert: Alert?
    let isPost: Bool
    
    var body: some View {
        VStack {
            Text(.init("PRE-DM-TITLE"))
                .font(.system(size: 15)).bold()
            Text(.init("PRE-DM-DESCRIPTION"))
                .padding(.vertical)
                .multilineTextAlignment(.center)
            ZStack {
                if errorX == "" {
                    VStack {
                        ZStack {
                            ProgressBar(value: $downloadProgress, length: 350)
                                .onReceive(timer, perform: { _ in
                                    if let sizeCode = try? call("stat -f %z ~/.patched-sur/InstallAssistant.pkg") {
                                        currentSize = Int(Float(sizeCode) ?? 10000)
                                        downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
                                        progressHuman = downloadProgress * 12.2
                                    }
                                })
                            HStack {
                                Image("DownloadArrow")
                                Text(NSLocalizedString("PRE-DM-BAR", comment: "PRE-DM-BAR").description.replacingOccurrences(of: "XX.YY.ZZ", with: installInfo?.version ?? ""))
                                    .onAppear {
                                        DispatchQueue(label: "DownloadMacOS").async {
                                            if installInfo!.buildNumber.hasPrefix("Custom") {
                                                withAnimation {
                                                    p = .volume
                                                }
                                                return
                                            }
                                            DispatchQueue.main.async {
                                                onExit = {
                                                    let al = NSAlert()
                                                    al.informativeText = NSLocalizedString("PRE-DM-CANCEL-1", comment: "PRE-DM-CANCEL-1")
                                                    al.messageText = NSLocalizedString("PRE-DM-CANCEL-2", comment: "PRE-DM-CANCEL-2")
                                                    al.showsHelp = false
                                                    al.addButton(withTitle: NSLocalizedString("CANCEL-DOWNLOAD", comment: "CONTINUE-DOWNLOAD"))
                                                    al.addButton(withTitle: NSLocalizedString("RESTART-DOWNLOAD", comment: "CONTINUE-DOWNLOAD"))
                                                    al.addButton(withTitle: NSLocalizedString("CONTINUE-DOWNLOAD", comment: "CONTINUE-DOWNLOAD"))
                                                    switch al.runModal() {
                                                    case .alertFirstButtonReturn:
                                                        _ = try? call("killall curl")
    //                                                    _ = try? call("sleep 0.25")
    //                                                    downloadStatus = "Downloading Files..."
                                                        return .confirm
                                                    case .alertSecondButtonReturn:
                                                        _ = try? call("killall curl")
                                                        _ = try? call("sleep 0.25")
                                                        errorX = ""
                                                        return .cancel
                                                    default:
                                                        return .cancel
                                                    }
                                                }
                                            }
                                            macOSDownload(installInfo: installInfo, size: { downloadSize = $0 }, next: {
                                                print("Verifying installer location")
                                                guard let path = (try? File(path: "~/.patched-sur/InstallAssistant.pkg"))?.path else {
                                                    print("Failed to resolve installer path.")
                                                    errorX = "Failed to resolve installer path.\nThis means an unknown error occurred while downloading the macOS InstallAssistant.\nPlease go back and try again.\nThis is not a patcher bug."
                                                    return
                                                }
                                                print("Verifying installer download finished")
                                                var alert: Alert?
                                                guard verifyInstaller(alert: &alert, path: path) else {
                                                    errorX = "The macOS download failed.\nThe reason for this is unknown since the download should not have cut out, unless something outside of the patcher was messing with it.\nPlease go back and try again.\nThis is not a patcher bug."
                                                    return
                                                }
                                                installInfo = .init(url: path, date: "", buildNumber: "CustomPKG", version: installInfo!.version, minVersion: 0, orderNumber: 0, notes: nil)
                                                withAnimation {
                                                    onExit = { .confirm }
                                                    p = .volume
                                                }
                                            }, errorX: {
                                                errorX = $0
                                                DispatchQueue.main.async {
                                                    onExit = {
                                                        let al = NSAlert()
                                                        al.informativeText = NSLocalizedString("PRE-DM-CANCEL-3", comment: "PRE-DM-CANCEL-3")
                                                        al.messageText = NSLocalizedString("PRE-DP-CANCEL-4", comment: "PRE-DP-CANCEL-4")
                                                        al.showsHelp = false
                                                        al.addButton(withTitle: NSLocalizedString("RESTART-DOWNLOAD", comment: "RESTART-DOWNLOAD"))
                                                        al.addButton(withTitle: NSLocalizedString("GO-BACK", comment: "GO-BACK"))
                                                        al.addButton(withTitle: NSLocalizedString("CANCEL", comment: "CANCEL"))
                                                        switch al.runModal() {
                                                        case .alertFirstButtonReturn:
                                                            errorX = ""
                                                            return .cancel
                                                        case .alertSecondButtonReturn:
                                                            return .confirm
                                                        default:
                                                            return .cancel
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                    }
                                    .padding(.vertical, 7)
                            }.foregroundColor(.white)
                        }
                        Text("\(progressHuman) / 12.2 GB")
                    }
                } else {
                    VIError(errorX)
                }
            }.fixedSize()
        }.alert($alert)
    }
}
