//
//  macOSDownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/16/21.
//

import VeliaUI

struct macOSDownloadView: View {
    @State var errorX = ""
    @State var downloadSize = 55357820
    @State var downloadProgress = CGFloat(0)
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
                    ProgressBar(value: $downloadProgress, length: 350)
                        .onReceive(timer, perform: { _ in
                            if let sizeCode = try? call("stat -f %z ~/.patched-sur/InstallAssistant.pkg") {
                                currentSize = Int(Float(sizeCode) ?? 10000)
                                downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
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
                                        withAnimation {
                                            p = .volume
                                        }
                                    }, errorX: { errorX = $0 })
                                }
                            }
                            .padding(.vertical, 7)
                    }.foregroundColor(.white)
                } else {
                    VIError(errorX)
                }
            }.fixedSize()
        }
    }
}
