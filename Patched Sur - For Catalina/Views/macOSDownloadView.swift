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
    
    var body: some View {
        VStack {
            Text("Download macOS")
                .font(.system(size: 15)).bold()
            Text("Currently, macOS is being downloaded straight from Apple so that you can update your Mac. This is a full installer, so it's a 12 GB download. It'll take a while, so let it go and make sure that your internet connection is good. After this is done, you'll have to select a USB drive to use for the installer then Patched Sur will use this file make the installer USB.")
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
                                Text("Downloading macOS \(installInfo?.version ?? "")...")
                                    .onAppear {
                                        DispatchQueue.global(qos: .background).async {
                                            if installInfo!.buildNumber.hasPrefix("Custom") {
                                                withAnimation {
                                                    p = .volume
                                                }
                                                return
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
                                                    p = .volume
                                                }
                                            }, errorX: { errorX = $0 })
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
        }
    }
}
