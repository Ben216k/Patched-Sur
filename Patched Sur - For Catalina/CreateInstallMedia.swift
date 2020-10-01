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
                                do {
                                    let diskUtilList = try shellOut(to: "diskutil list /Volumes/\(volume.replacingOccurrences(of: " ", with: "\\ "))")
                                    var diskStart = diskUtilList.split(separator: "\n")[2]
                                    diskStart.removeFirst("   0:      GUID_partition_scheme                        *32.0 GB    ".count)
                                    let diskID = diskStart.prefix(5)
                                    try shellOut(to: "diskutil eraseDisk JHFS+ Install\\ macOS\\ Big\\ Sur\\ Beta GPT \(diskID)")
                                    downloadStatus = "Copying Installer..."
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
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
                    Text("Copying Installer...") 
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    
                                }
                            }
                        }
                } else {
                    Color.red
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text(downloadStatus)
                        .lineLimit(4)
                        .foregroundColor(.white)
                        .padding(6)
                        .padding(.horizontal, 4)
                }
            }.fixedSize()
        }
    }
}
