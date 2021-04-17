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
            Text("Downloading Patches")
                .font(.system(size: 15)).bold()
            Text("The set vars tool allows you to properly setup the NVRAM and SIP status, so that Big Sur lets you boot into it. \(!isPost ? "This is the last tool you will use before installing Big Sur." : "You will only need this if you haven't run it before on that Mac or if you did a PRAM reset.") The kext patches allow you to use hardware like WiFi and USB ports, so that your Mac stays at its full functionality.")
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
                            Text("Downloading Files")
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
                                        al.informativeText = "The patches that will later be used by the patcher are currently downloading. Are you sure you want to go back?"
                                        al.messageText = "The Patches Are Downloading"
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
                                                    al.informativeText = "The patches failed to download, however this could be solved by trying again. Would you like to attempt to download the patches again or go to the previous step?"
                                                    al.messageText = "Would you like to restart the download?"
                                                    al.showsHelp = false
                                                    al.addButton(withTitle: "Restart Download")
                                                    al.addButton(withTitle: "Go Back")
                                                    al.addButton(withTitle: "Cancel")
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
