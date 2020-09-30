//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files

struct InstallPackageView: View {
    @State var downloadStatus = "Fetching URLs..."
    @State var installInfo: InstallAssistant?
    @State var downloadProgress: CGFloat = 0
    @Binding var p: Int
    
    var body: some View {
        VStack {
            Text("Downloading Install Assistant Package").bold()
            Text("The Install Assistant is the file that contains the macOS installer used to, well, install macOS. In our case, we can't just use the app. Later on (the next step), we need to use the createinstallmedia tool provided by this package to create an installer USB. This USB drive then has to be patched so it will even let us boot into it. Simple enough, right?")
                .padding()
                .multilineTextAlignment(.center)
            ZStack {
                if downloadStatus == "Fetching URLs..." {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text("Fetching URLs...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    let allInstallInfo = try InstallAssistants(fromURL: "https://bensova.github.io/patched-sur/installers/Developer.json")
                                    installInfo = allInstallInfo.sorted(by: { (one, two) -> Bool in
                                        if one.orderNumber > two.orderNumber {
                                            return true
                                        }
                                        return false
                                    })[0]
                                    downloadStatus = "Downloading macOS \(installInfo!.version)..."
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                        .padding(6)
                        .padding(.horizontal, 4)
                } else if downloadStatus.hasPrefix("Downloading macOS ") {
                    ZStack(alignment: .leading) {
                        Color.secondary
                            .cornerRadius(10)
                            .frame(width: 300)
                        Color.blue
                            .cornerRadius(10)
                            .frame(width: 300 * downloadProgress)
                    }
                    Text(downloadStatus)
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            if (try? (try? File(path: "~/.patched-sur/InstallerVersion.txt"))?.readAsString()) == installInfo?.version {
                                p = 4
                                return
                            }
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    try shellOut(to: "curl -o InstallAssistant.pkg \(installInfo!.url)", at: "~/.patched-sur")
                                    let versionFile = try Folder(path: "~/.patched-sur").createFileIfNeeded(at: "InstallerVersion.txt")
                                    try versionFile.write(installInfo!.version, encoding: .utf8)
                                    p = 4
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                    Text(downloadStatus)
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onTapGesture {
                            NSPasteboard.general.setString(downloadStatus, forType: .string)
                        }
                }
            }
            .fixedSize()
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView(p: .constant(2))
            .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
            .background(Color.white)
    }
}
