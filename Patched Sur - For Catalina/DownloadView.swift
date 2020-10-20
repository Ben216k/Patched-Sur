//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files

struct DownloadView: View {
    @State var downloadStatus = "Starting Download..."
    @State var setVarsTool: Data?
    @State var setVarsZip: File?
    @State var setVarsSave: Folder?
    @Binding var p: Int
    @State var buttonBG = Color.red
    
    var body: some View {
        VStack {
            Text("Downloading Set Vars Tool and Kext Patches").bold()
            Text("The set vars tool allows you to properly setup the nvram and sip status, so that Big Sur let's you boot into it. This is the last tool you use before installing Big Sur. The kext patches allow you to use stuff like WiFi and USB ports, so that your Mac stays at full functionality.")
                .padding(10)
                .multilineTextAlignment(.center)
            ZStack {
                Color.secondary
                    .cornerRadius(10)
                    .frame(minWidth: 200, maxWidth: 450)
                if downloadStatus == "Starting Download..." {
                    Text("Starting Download...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    _ = try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
//                                    if (try? appDir.subfolder(named: "big-sur-micropatcher")) != nil {
//                                        try shellOut(to: "git pull", at: "~/.patched-sur/big-sur-micropatcher")
//                                    } else {
//                                        try shellOut(to: "git clone https://github.com/barrykn/big-sur-micropatcher.git", at: "~/.patched-sur")
//                                        _ = try appDir.subfolder(named: "big-sur-micropatcher")
//                                    }
                                    _ = try? Folder(path: "~/.patched-sur/big-sur-micropatcher").delete()
                                    _ = try? File(path: "~/.patched-sur/big-sur-micropatcher-\(AppInfo.micropatcher).zip").delete()
                                    try shellOut(to: "curl -Lo big-sur-micropatcher-\(AppInfo.micropatcher).zip https://github.com/barrykn/big-sur-micropatcher/archive/\(AppInfo.micropatcher).zip", at: "~/.patched-sur")
                                    try shellOut(to: "unzip ~/.patched-sur/big-sur-micropatcher-\(AppInfo.micropatcher).zip", at: "~/.patched-sur")
                                    _ = try? File(path: "~/.patched-sur/big-sur-micropatcher-\(AppInfo.micropatcher).zip").delete()
                                    try shellOut(to: "mv big-sur-micropatcher-0.4.2 big-sur-micropatcher", at: "~/.patched-sur")
                                    p = 4
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                        .padding(6)
                        .padding(.horizontal, 4)
                } else {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(downloadStatus, forType: .string)
                    } label: {
                        ZStack {
                            buttonBG
                                .cornerRadius(10)
                                .frame(minWidth: 200, maxWidth: 450)
                                .onHover(perform: { hovering in
                                    buttonBG = hovering ? Color.red.opacity(0.7) : .red
                                })
                                .onAppear(perform: {
                                    if buttonBG != .red && buttonBG != Color.red.opacity(0.7) {
                                        buttonBG = .red
                                    }
                                })
                            Text(downloadStatus)
                                .foregroundColor(.white)
                                .lineLimit(6)
                                .padding(6)
                                .padding(.horizontal, 4)
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            .fixedSize()
        }
    }
}
