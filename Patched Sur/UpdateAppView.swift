//
//  UpdateAppView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/25/20.
//

import SwiftUI
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
                Button {
                    p = -1
                } label: {
                    ZStack {
                        ZStack {
                            if downloading {
                                Color.secondary.opacity(0.7).cornerRadius(10)
                            } else {
                                hovered == "BACK-HOME" ? Color.secondary.opacity(0.7).cornerRadius(10) : Color.secondary.cornerRadius(10)
                            }
                            Text("Back")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "BACK-HOME" : nil
                        }
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    skipCheck = true
                    p = 0
                } label: {
                    ZStack {
                        ZStack {
                            if downloading {
                                Color.secondary.opacity(0.7).cornerRadius(10)
                            } else {
                                hovered == "SKIP-UPDATE" ? Color.secondary.opacity(0.7).cornerRadius(10) : Color.secondary.cornerRadius(10)
                            }
                            Text("Skip")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "SKIP-UPDATE" : nil
                        }
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Text("Patched Sur \(latest.name)")
                    .font(.title2)
                    .bold()
                Spacer()
                if downloading {
                    ZStack {
                        ZStack(alignment: .leading) {
                            Color.accentColor.opacity(0.4).frame(width: 140)
                            Color.accentColor.frame(width: min(downloadProgress * 140, 140))
                        }.cornerRadius(10)
                        .onReceive(timer, perform: { _ in
                            if let sizeCode = try? call("stat -f %z ~/.patched-sur/Patched-Sur.zip") {
                                currentSize = Int(Float(sizeCode) ?? 10000)
                                downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(latest.assets[1].size)
                            }
                        })
                        Text("Downloading Update")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .padding(6)
                            .padding(.horizontal, 3)
                            .onAppear {
                                DispatchQueue.global(qos: .background).async {
                                    do {
                                        print("Pre-Download Clean Up...")
                                        try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
                                        _ = try? File(path: "~/.patched-sur/Patched-Sur.zip").delete()
                                        _ = try? Folder(path: "~/.patched-sur/Patched Sur.app").delete()
                                        print("Getting download size of Patched Sur...")
                                        if let sizeString = try? call("curl -sI \(latest.assets[1].browserDownloadURL) | grep -i Content-Length | awk '{print $2}'"), let sizeInt = Int(sizeString) {
                                            downloadSize = sizeInt
                                        }
                                        print("Projected size: \(downloadSize)")
                                        print("Starting Download of updated Patched Sur...")
                                        try call("curl -L \(latest.assets[2].browserDownloadURL) -o ~/.patched-sur/Patched-Sur.zip")
                                        print("Unzipping download...")
                                        try call("unzip ~/.patched-sur/Patched-Sur.zip")
                                        print("Starting Patched Sur Updater...")
                                        let appOutput = try call("~/.patched-sur/Patched\\ Sur.app/Contents/MacOS/Patched\\ Sur --update")
                                        print(appOutput)
                                        print("Updater started, closing app.")
                                        NSApplication.shared.terminate(nil)
                                    } catch {
                                        print(error.localizedDescription)
                                        errorMessage = "Download Failed"
                                        downloading = false
                                    }
                                }
                            }
                    }.frame(width: 140)
                    .fixedSize()
                } else if errorMessage != "" {
                    Button {
                        downloading = true
                    } label: {
                        ZStack {
                            hovered == "DOWNLOAD-UPDATE" ? Color.red.opacity(0.7).cornerRadius(10) : Color.red.cornerRadius(10)
                            Text("Try Again")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "DOWNLOAD-UPDATE" : nil
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .fixedSize()
                } else {
                    Button {
                        downloading = true
                    } label: {
                        ZStack {
                            hovered == "DOWNLOAD-UPDATE" ? Color.accentColor.opacity(0.7).cornerRadius(10) : Color.accentColor.cornerRadius(10)
                            Text("Download Update")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .padding(6)
                                .padding(.horizontal, 3)
                        }.onHover { hovering in
                            hovered = hovering ? "DOWNLOAD-UPDATE" : nil
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .fixedSize()
                }
            }
            ScrollView {
                Text(latest.body)
            }
        }.padding(20)
    }
}
