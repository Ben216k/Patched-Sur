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
    @State var downloadProgress = 0 as CGFloat
    @State var errorMessage = ""
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
                            Color.accentColor.opacity(0.4).cornerRadius(10)
                            Color.accentColor.cornerRadius(10).frame(width: downloadProgress * 140)
                        }
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
                                        print("Starting Download of updated Patched Sur...")
                                        try shellOut(to: "curl -L \(latest.assets[1].browserDownloadURL) -o ~/.patched-sur/Patched-Sur.zip")
                                        print("Unzipping download...")
                                        try shellOut(to: "unzip ~/.patched-sur/Patched-Sur.zip")
                                        print("Starting Patched Sur Updater...")
                                        let appOutput = try shellOut(to: "~/.patched-sur/Patched\\ Sur.app/Contents/MacOS/Patched\\ Sur --update")
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
