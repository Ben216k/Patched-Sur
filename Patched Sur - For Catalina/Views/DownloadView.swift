//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import VeliaUI
import Files

struct DownloadKextsView: View {
    @State var downloadStatus = "Downloading Files..."
    @State var setVarsTool: Data?
    @State var setVarsZip: File?
    @State var setVarsSave: Folder?
    @Binding var p: PSPage
    @State var buttonBG = Color.red
    @State var downloadSize = 55357820
    @State var downloadProgress = CGFloat(0)
    @State var currentSize = 10
    @Binding var hasKexts: Bool
    let timer = Timer.publish(every: 0.50, on: .current, in: .common).autoconnect()
    @Binding var onExit: () -> (BackMode)
    @State var alert: Alert?
    let isPost: Bool
    @Binding var installInfo: InstallAssistant?
    @State var startedDownload = false
    
    var body: some View {
        VStack {
            Text(.init("DOWNLOAD-PATCHES"))
                .font(.system(size: 15)).bold()
            Text("\(NSLocalizedString("PRE-DP-1", comment: "PRE-DP-1")) \(!isPost ? NSLocalizedString("PRE-DP-2", comment: "PRE-DP-2") : NSLocalizedString("PRE-DP-3", comment: "PRE-DP-3")) \(NSLocalizedString("PRE-DP-4", comment: "PRE-DP-4"))")
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
            ZStack {
                if downloadStatus == "Downloading Files..." {
//                    ProgressBar(value: $downloadProgress, length: 200)
//                        .onReceive(timer, perform: { _ in
//                            if let sizeCode = try? call("stat -f %z ~/.patched-sur/Patched-Sur-Patches.zip") {
//                                currentSize = Int(Float(sizeCode) ?? 10000)
//                                downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
//                            }
//                        })
                    VIButton(id: "DOWNLOAD-NEVER", h: .constant("HAHAH")) {
                        HStack {
                            Image("DownloadArrow")
                            Text(.init("DOWNLOAD-FILES"))
                                .onAppear {
                                    if startedDownload {
                                        return
                                    } else {
                                        startedDownload = true
                                    }
                                    if hasKexts == true || (try? call("[[ -e '\(Bundle.main.sharedSupportPath ?? "SHSDJLSHDFJKHDS")/Patched-Sur-Patches.zip' ]]")) != nil {
                                        withAnimation {
                                            if installInfo!.buildNumber.hasPrefix("Custom") {
                                                withAnimation {
                                                    p = .volume
                                                }
                                            } else {
                                                withAnimation {
                                                    p = .package
                                                }
                                            }
                                        }
                                        return
                                    } else if let patcV = try? call("cat /usr/local/lib/Patched-Sur-Patches/pspVersion"), patcV == AppInfo.patchesV.version {
                                        withAnimation {
                                            if installInfo!.buildNumber.hasPrefix("Custom") {
                                                withAnimation {
                                                    p = .volume
                                                }
                                            } else {
                                                withAnimation {
                                                    p = .package
                                                }
                                            }
                                        }
                                        return
                                    }
                                    onExit = {
                                        let al = NSAlert()
                                        al.informativeText = NSLocalizedString("PRE-DP-CANCEL-1", comment: "PRE-DP-CANCEL-1")
                                        al.messageText = NSLocalizedString("PRE-DP-CANCEL-2", comment: "PRE-DP-CANCEL-2")
                                        al.showsHelp = false
                                        al.addButton(withTitle: NSLocalizedString("CANCEL-DOWNLOAD", comment: "CANCEL-DOWNLOAD"))
                                        al.addButton(withTitle: NSLocalizedString("RESTART-DOWNLOAD", comment: "RESTART-DOWNLOAD"))
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
                                            downloadStatus = "Downloading Files..."
                                            return .cancel
                                        default:
                                            return .cancel
                                        }
                                    }
                                    DispatchQueue(label: "DownloadKexts", qos: .userInteractive).async {
                                        kextDownload(size: { downloadSize = $0 }, next: {
                                            hasKexts = true
                                            withAnimation {
                                                onExit = { .confirm }
                                                if installInfo!.buildNumber.hasPrefix("Custom") {
                                                    withAnimation {
                                                        p = .volume
                                                    }
                                                    return
                                                } else {
                                                    withAnimation {
                                                        p = .package
                                                    }
                                                }
                                            }
                                        }, errorX: {
                                            downloadStatus = $0
                                            DispatchQueue.main.async {
                                                onExit = {
                                                    let al = NSAlert()
                                                    al.informativeText =  NSLocalizedString("PRE-DP-CANCEL-3", comment: "PRE-DP-CANCEL-3")
                                                    al.messageText =  NSLocalizedString("PRE-DP-CANCEL-4", comment: "PRE-DP-CANCEL-4")
                                                    al.showsHelp = false
                                                    al.addButton(withTitle: NSLocalizedString("RESTART-DOWNLOAD", comment: "RESTART-DOWNLOAD"))
                                                    al.addButton(withTitle: NSLocalizedString("GO-BACK", comment: "GO-BACK"))
                                                    al.addButton(withTitle: NSLocalizedString("CANCEL", comment: "CANCEL"))
                                                    switch al.runModal() {
                                                    case .alertFirstButtonReturn:
                                                        downloadStatus = "Downloading Files..."
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
//                                .padding(.vertical, 7)
                        }
                    }.btColor(.gray)
                    .inPad()
                } else {
                    VIError(downloadStatus)
                }
            }
            .fixedSize()
            .alert($alert)
        }
    }
}

struct ProgressBar: View {
    @Binding var value: CGFloat
    var length: CGFloat = 285
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(minWidth: length)
                .opacity(0.3)
                .foregroundColor(Color("Accent").opacity(0.9))
            
            Rectangle().frame(width: min(value*length, length))
                .foregroundColor(Color("Accent"))
                .animation(.linear)
        }.cornerRadius(20)
    }
}
