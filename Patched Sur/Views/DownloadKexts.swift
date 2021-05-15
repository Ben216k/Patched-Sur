//
//  DownloadKexts.swift
//  Patched Sur

//
//  Created by Benjamin Sova on 12/08/20.
//

import VeliaUI
import Files
import IOKit
import IOKit.pwr_mgt

struct DownloadView: View {
    @State var downloadStatus = "Downloading Patches..."
    @State var setVarsTool: Data?
    @State var setVarsZip: File?
    @State var setVarsSave: Folder?
    @Binding var p: Int
    @State var buttonBG = Color.red
    @State var downloadSize = 63216475
    @State var installSize = 21382031300000
    @State var assistantSizeTxt = "0"
    @State var downloadProgress = CGFloat(0)
    @State var installProgress = CGFloat(0)
    @State var currentSize = 10
    @Binding var installInfo: InstallAssistant?
    @State var kextDownloaded = false
    @Binding var useCurrent: Bool
    @State var hovered: String?
    @Binding var showPassPrompt: Bool
    @Binding var password: String
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text(useCurrent ? .init("DOWNLOAD-PATCHES"): .init("DOWNLOAD-PATCH-MACOS"))
                .font(.system(size: 15)).bold()
            Text(.init("PO-UP-DPM-DESCRIPTION"))
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
            if showPassPrompt || password == "" {
                VIButton(id: "REQUEST", h: $hovered) {
                    Text(.init("REQUEST-ROOT"))
                } onClick: {
                    withAnimation {
                        showPassPrompt = true
                    }
                }.inPad().onAppear {
                    withAnimation(Animation.default.delay(0.25)) {
                        showPassPrompt = true
                    }
                }
            } else if downloadStatus == "Downloading Patches..." {
                VStack {
                    ZStack {
                        if kextDownloaded {
                            VIButton(id: " ", h: .constant("")) {
                                HStack {
                                    Image("CheckCircle")
                                    Text(.init("DOWNLOADED-PATCHES"))
                                }.frame(width: 216)
                            }.btColor(.gray)
                        } else {
                            ProgressBar(value: $downloadProgress, length: 230)
                                .onReceive(timer, perform: { _ in
                                    if kextDownloaded {
                                        downloadProgress = 1
                                    } else {
                                        if let sizeCode = try? call("stat -f %z ~/.patched-sur/Patched-Sur-Patches.zip") {
                                            currentSize = Int(Float(sizeCode) ?? 10000)
                                            downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
                                        }
                                    }
                                })
                            HStack {
                                Image("FileCircle")
                                    .foregroundColor(.white)
                                Text(.init("DOWNLOAD-PATCHES"))
                                    .foregroundColor(.white)
                                    .lineLimit(4)
                                    .onAppear {
                                        DispatchQueue.global(qos: .background).async {
                                            AppInfo.canReleaseAttention = false
                                            if !AppInfo.usePredownloaded {
                                                upDownloadKexts(useCurrent: useCurrent, installInfo: installInfo!) {
                                                    downloadSize = $0
                                                } kextDownloaded: {
                                                    kextDownloaded = true
                                                } errorX: {
                                                    downloadStatus = $0
                                                } done: {
                                                    if installInfo!.buildNumber != "CustomAPP" && installInfo!.buildNumber != "CustomPKG" && !AppInfo.nothing {
                                                        print("Verifying download...")
                                                        var alert: Alert?
                                                        guard let installerFile = try? File(path: "~/.patched-sur/InstallAssistant.pkg") else {
                                                            downloadStatus = "An unknown error occurred downloading the macOS installer.\nThis is probably an issue with your connection and not a patcher bug.\n\n(Debugger Code: Error 3x1)"
                                                            return
                                                        }
                                                        guard verifyInstaller(alert: &alert, path: installerFile.path) else {
                                                            downloadStatus = "An unknown error occurred downloading the macOS installer.\nThis is probably an issue with your connection and not a patcher bug.\n\n(Debugger Code: Error 3x2)"
                                                            return
                                                        }
                                                        installInfo = .init(url: installerFile.path, date: "", buildNumber: "", version: "", minVersion: 0, orderNumber: 0, notes: nil)
                                                    }
                                                    withAnimation {
                                                        p = 4
                                                    }
                                                }
                                            } else {
                                                kextDownloaded = true
                                                p = 4
                                            }
                                        }
                                    }
                            }
                            .padding(6)
                            .padding(.horizontal, 4)
                        }
                    }
                }.fixedSize()
                if !(installInfo!.buildNumber.contains("Custom")) {
                    ZStack {
                        ProgressBar(value: $installProgress, length: 230)
                            .onReceive(timer, perform: { _ in
                                if let sizeCode = try? call("stat -f %z ~/.patched-sur/InstallAssistant.pkg") {
                                    currentSize = Int(Float(sizeCode) ?? 10000)
                                    installProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(12228568900)
                                    assistantSizeTxt = (try? call("echo \(sizeCode) | awk '{ print $1/1000000000 }'")) ?? "0.0"
                                }
                            })
                        HStack {
                            Image("DownloadArrow")
                                .foregroundColor(.white)
                            Text(.init("DOWNLOADING-MACOS"))
                                .foregroundColor(.white)
                                .lineLimit(4)
                        }.padding(6)
                        .padding(.horizontal, 4)
                    }.fixedSize()
                    Text("\(assistantSizeTxt) / 12 GB")
                        .font(.caption)
                }
            } else {
                VIError(downloadStatus)
            }
        }
    }
}
