//
//  CreateInstallMedia.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct CreateInstallMedia: View {
    @State var downloadStatus = "Erasing Disk..."
    @Binding var volume: String
    @Binding var password: String
    @Binding var overrideInstaller: Bool
    @State var diskID = ""
    @State var buttonBG = Color.red
    @Binding var p: Int
    var body: some View {
        VStack {
            Text("Creating Install Media").bold()
            Text("Due to the fact that the installer app cannot be natively run on an unsupported Mac, you have to create an installer USB where the environment can be modified so macOS doesn't check whether or not you're supported.")
                .padding()
                .multilineTextAlignment(.center)
            ZStack {
                if downloadStatus == "Erasing Disk..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Erasing Disk...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
////                                if (try? shellOut(to: "[[ -d '/Volumes/Install macOS Big Sur Beta/Install macOS Big Sur Beta.app' ]]")) != nil {
////                                    downloadStatus = "Adding Kexts..."
////                                    return
////                                }
                                downloadStatus = "Installing SetVars Tool..."
//                                do {
//                                    let diskUtilList = try shellOut(to: "diskutil list /Volumes/\(volume.replacingOccurrences(of: " ", with: "\\ "))")
//                                    var diskStart = diskUtilList.split(separator: "\n")[2]
//                                    diskStart.removeFirst("   0:      GUID_partition_scheme                        *32.0 GB    ".count)
//                                    diskID = String(diskStart.prefix(5))
//                                    try shellOut(to: "diskutil eraseDisk JHFS+ Install\\ macOS\\ Big\\ Sur\\ Beta GPT \(diskID)")
////                                    downloadStatus = "Copying Installer..."
//                                    downloadStatus = "Installing SetVars Tool..."
//                                } catch {
//                                    downloadStatus = error.localizedDescription
//                                }
                            }
                        }
                } else if downloadStatus == "Copying Installer..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Copying Installer...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    try shellOut(to: "echo \"\(password)\" | sudo -S /Applications/Install\\ macOS\\ Big\\ Sur\\ Beta.app/Contents/Resources/createinstallmedia --volume /Volumes/Install\\ macOS\\ Big\\ Sur\\ Beta --nointeraction")
                                    downloadStatus = "Adding Kexts..."
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else if downloadStatus == "Adding Kexts..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Micropatching USB...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    try shellOut(to: "~/.patched-sur/big-sur-micropatcher/micropatcher.sh")
                                    downloadStatus = "Installing SetVars Tool..."
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else if downloadStatus == "Installing SetVars Tool..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Installing SetVars Tool...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    try shellOut(to: "echo \"\(password)\" | sudo -S ~/.patched-sur/big-sur-micropatcher/install-setvars.sh")
                                    downloadStatus = "Injecting Full App..."
                                } catch {
                                    if error.localizedDescription.hasPrefix("""
                                    ShellOut encountered an error
                                    Status code: 1
                                    Message: "Password:Volume on \(diskID)s1 failed to mount"
                                    """) {
                                        downloadStatus = "Injecting Full App..."
                                    }
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else if downloadStatus == "Injecting Full App..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Injecting Full App...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .utility).async {
                                do {
                                    try shellOut(to: "cp -rf \"/Volumes/Patched-Sur-\(AppInfo.version)/.fullApp.app\" \"/Applications/Patched Sur.app\"")
                                    p = 8
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
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
            }.fixedSize()
        }
    }
}
