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
            Text("Download macOS")
                .font(.system(size: 15)).bold()
            Text("Currently, macOS is being downloaded straight from Apple \(!isPost ? "so that you can update your Mac" : "so it can be put on the installer USB"). This is a full installer, so it's a 12 GB download. It'll take a while, so let it go and make sure that your internet connection is good. After this is done, you'll have to select a USB drive to use for the installer then Patched Sur will use this file make the installer USB.")
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
                                Text("Downloading macOS \(installInfo?.version ?? "")")
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
                                                    al.informativeText = "The macOS Big Sur is currently being downloaded so that it can be used later. This is a big download. Are you sure you want to go back?"
                                                    al.messageText = "macOS is Downloading"
                                                    al.showsHelp = false
                                                    al.addButton(withTitle: "Cancel Download")
                                                    al.addButton(withTitle: "Restart Download")
                                                    al.addButton(withTitle: "Continue Download")
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
                                                        al.informativeText = "macOS failed to download, however this could be solved by trying again. Would you like to attempt to download macOS again or go to the previous step?"
                                                        al.messageText = "Would you like to restart the download?"
                                                        al.showsHelp = false
                                                        al.addButton(withTitle: "Restart Download")
                                                        al.addButton(withTitle: "Go Back")
                                                        al.addButton(withTitle: "Cancel")
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
