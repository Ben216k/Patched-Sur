//
//  UpdateAppView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/25/20.
//

import VeliaUI
import Files

struct UpdateAppView: View {
    let latest: PatchedVersion
    @State var hovered = nil as String?
    @Binding var p: Int
    @State var downloading = false
    @State var errorMessage = ""
    @Binding var skipCheck: Bool
    @State var downloadSize = 55357820
    @State var downloadProgress = CGFloat(0)
    @State var currentSize = 10
    let timer = Timer.publish(every: 0.25, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Patched Sur \(latest.name)")
//                Text("Patched Sur v0.1.0 Beta")
                    .font(.title2)
                    .bold()
                Spacer()
            }.padding(.top, 5)
            ScrollView {
                Text(latest.body)
//                Text(releaseNotesThing)
            }.padding(.top, -3)
            HStack {
                VIButton(id: "SKIP", h: $hovered) {
                    Text(.init("SKIP"))
                    Image("ForwardArrowCircle")
                } onClick: {
                    if !downloading {
                        skipCheck = true
                        p = 0
                    }
                }.inPad()
                .btColor(.gray)
                if errorMessage != "" {
                    VIButton(id: "DOWNLOAD-FAILED", h: $hovered) {
                        Image("ExclaimCircle")
                        Text(.init("PO-UP-APP-FAILED"))
                    } onClick: {
                        errorMessage = ""
                        downloading = true
                    }.inPad()
                    .btColor(.red)
                } else if !downloading {
                    VIButton(id: "DOWNLOAD-UPDATE", h: $hovered) {
                        Text(.init("PO-UP-APP-START"))
                        Image("DownloadArrow")
                    } onClick: {
                        downloading = true
                    }.inPad()
                } else {
                    ZStack {
                        ProgressBar(value: $downloadProgress, length: 160)
                            .onReceive(timer, perform: { _ in
                                if let sizeCode = try? call("stat -f %z ~/.patched-sur/Patched-Sur.zip") {
                                    currentSize = Int(Float(sizeCode) ?? 10000)
                                    downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(latest.assets[1].size)
                                }
                            })
                        HStack {
                            Image("DownloadArrow").foregroundColor(.white)
                            Text(.init("DOWNLOADING")).foregroundColor(.white)
                        }.padding(6)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    print("Pre-Download Clean Up...")
                                    try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
                                    _ = try? File(path: "~/.patched-sur/Patched-Sur.zip").delete()
                                    _ = try? File(path: "~/.patched-sur/__MACOSX").delete()
                                    _ = try? Folder(path: "~/.patched-sur/Patched Sur.app").delete()
                                    print("Getting download size of Patched Sur...")
                                    if let sizeString = try? call("curl -sI \(latest.assets[1].browserDownloadURL) | grep -i Content-Length | awk '{print $2}'"), let sizeInt = Int(sizeString) {
                                        downloadSize = sizeInt
                                    }
                                    print("Projected size: \(downloadSize)")
                                    print("Starting Download of updated Patched Sur...")
                                    try call("curl -L \(latest.assets[2].browserDownloadURL) -o ~/.patched-sur/Patched-Sur.zip")
//                                        try call("curl -L https://cdn.discordapp.com/attachments/781937101338837012/81689537371701250/Patched_Sur.app.zip -o ~/.patched-sur/Patched-Sur.zip")
                                    print("Unzipping download...")
                                    try call("unzip ~/.patched-sur/Patched-Sur.zip")
                                    print("Starting Patched Sur Updater...")
                                    let appOutput = try call("~/.patched-sur/Patched\\ Sur.app/Contents/MacOS/Patched\\ Sur --update")
                                    print(appOutput)
                                    print("Updater started, closing app.")
                                    relaunchPatcher()
                                } catch {
                                    print(error.localizedDescription)
                                    errorMessage = "Download Failed"
                                    downloading = false
                                }
                            }
                        }
                    }.fixedSize()
                }
            }.padding(.bottom, 10)
        }
        .onAppear {
            UserDefaults.standard.setValue(latest.tagName, forKey: "LastCheckedPSVersion")
        }
    }
}
//
//let releaseNotesThing = """
//Patched Sur v0.1.0 is a big update with one pretty big thing that will help make the unsupported Mac experience more like a real Mac. You can now download software updates without needing to make a new USB installer like before. There's also a way to enable update notifications, so you never miss one (unless you hated those like me). I'll add a little bit more to these notes once I have time, but I just really wanted to get this update out haha.
//
//## New Features
//- Patched Sur now has an updater for macOS inside the post-install app.
//- You can now get update notifications for both the patcher and macOS.
//- You can set the patcher to auto-update.
//- There's a patch kexts logs section in Settings.
//
//## Bug Fixes
//- Remove the close button as a cheap workaround for closing all windows when the last window is closed in the pre-install app. (@Solomon-Wood)
//- Remove beta from some parts of the README (@Monkiey)
//"""
