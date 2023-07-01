//
//  DownloadingView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import SwiftUI
import Files
import OSLog

struct DownloadingView: View {
    @Binding var isShowingButtons: Bool
    @Binding var installInfo: InstallAssistant?
    @Binding var showMoreInformation: Bool
    @Binding var page: ContentView.PIPages
    @State var errorX: String?
    @State var progressHuman = 0 as CGFloat
    @State var currentSize = 10
    @State var downloadSize = 5535782000
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @Binding var progress: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle().opacity(0.00001)
                .onAppear {
                    withAnimation { isShowingButtons = false }
                    DispatchQueue.global(qos: .background).async {
                        macOSDownload(installInfo: installInfo) { int in
                            downloadSize = int
                        } next: {
                            OSLog.downloads.log("Verifying installer location")
                            guard let path = (try? File(path: "~/.patched-sur/InstallAssistant.pkg"))?.path else {
                                OSLog.downloads.log("Failed to resolve installer path.", type: .error)
                                errorX = "Failed to resolve installer path.\nThis means an unknown error occurred while downloading the macOS InstallAssistant.\nPlease go back and try again.\nThis is not a patcher bug."
                                return
                            }
                            OSLog.downloads.log("Verifying installer download finished")
                            var alert: Alert?
                            guard verifyInstaller(alert: &alert, path: path) else {
                                errorX = "The macOS download failed.\nThe reason for this is unknown since the download should not have cut out, unless something outside of the patcher was messing with it.\nPlease go back and try again.\nThis is not a patcher bug."
                                return
                            }
                            installInfo = .init(url: path, date: "", buildNumber: "CustomPKG", version: installInfo!.version, minVersion: 0, orderNumber: 0, notes: nil)
//                            withAnimation {}
                            OSLog.downloads.log("DONE")
                            page = .patching
                        } errorX: { errorX in
                            self.errorX = errorX
                        }

                    }
                }
                .onReceive(timer, perform: { _ in
                    if let sizeCode = try? call("stat -f %z ~/.patched-sur/InstallAssistant.pkg") {
                        currentSize = Int(Double(sizeCode) ?? 12439328867)
                        progress = CGFloat(Double(sizeCode) ?? 12439328867) / CGFloat(12452033864)
                        progressHuman = progress * 12.4
                    }
                })
            if !showMoreInformation || errorX != nil {
                VStack {
                    Spacer()
                    Text("Downaloding macOS")
                        .font(.system(size: 17, weight: .bold))
                        .padding(.bottom, 10)
                    if let errorX {
                        ErrorHandlingView(bubble: "An error occured attempting to download macOS Big Sur. This is most likely a network issue. The following error most likely has better information near the bottom.", fullError: errorX)
                    } else {
                        Text("Patched Sur is downloading the macOS Big Sur installer directly from Apple's own servers so that an installer USB can be created. This may take a while, since it is the entirety of macOS Big Sur. In the meantime, click below if you'd like to learn more about how Patched Sur works.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        ZStack {
                            ProgressBar(value: $progress, length: 250)
                            HStack {
                                Image("DownloadArrow")
                                Text("Downloading macOS")
                            }.foregroundColor(.white)
                                .padding(7)
                        }.fixedSize()
//                        Text("\(progressHuman) / 12.2 GB")
                        // Above but round to three decimal places
                        Text("\(String(format: "%.3f", progressHuman)) / 12.4 GB")
                            .font(.caption)
                    }
                    Spacer()
                }.transition(.moveAway)
            } else {
                VStack {
                    Text("Learn More About Patched Sur")
                        .font(.system(size: 17, weight: .bold))
                        .padding(.bottom, 10)
                    ScrollView {
                        Text(learnMore).padding(.horizontal).padding(.bottom, 50)
                    }
                }.transition(.moveAway)
            }
        }
    }
}


let learnMore = """
Generated by BingAI as a placeholder.

Patched Sur is a software tool that allows users to run macOS Big Sur, the latest version of Apple's operating system, on some Mac models that are officially unsupported by Apple. It was created by Ben216k and other contributors who developed patches and fixes for various issues that prevent Big Sur from running smoothly on older Macs¹.

Patched Sur works by creating a bootable USB installer that contains a modified version of the Big Sur installer app. The modified installer app bypasses the compatibility checks that normally prevent unsupported Macs from installing Big Sur. It also includes a patcher app that can apply various patches to the system files and kexts (kernel extensions) of Big Sur after installation. These patches enable features such as WiFi, graphics, audio, USB ports, and more on unsupported Macs¹.

Patched Sur also allows users to update their patched Big Sur system without using a USB installer. It does this by using the startosinstall command, which can install updates from the command line. Patched Sur also downloads and applies the latest patches automatically after each update¹.

Patched Sur is designed to be simple and user-friendly, with a graphical user interface that guides users through each step of the patching process. It also gives users some options and preferences on how they want to patch their system, such as choosing between different WiFi patches or enabling or disabling certain patches¹.

Patched Sur is compatible with most Mac models from 2012 and 2013 that have metal-capable GPUs. Some older models from 2009 to 2011 may also work with Patched Sur, but they may have more issues and limitations. Users can check the compatibility list on the GitHub page of Patched Sur before trying it¹.

Patched Sur is a free and open source project that is available on GitHub. Users can download the latest version of Patched Sur from the releases page or from MacUpdate. Users can also contribute to the development of Patched Sur by reporting bugs, suggesting features, translating the app, or making donations¹².
"""
