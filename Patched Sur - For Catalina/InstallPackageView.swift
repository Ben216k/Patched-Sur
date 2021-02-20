//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files
import Combine

struct InstallPackageView: View {
    @State var downloadStatus = "Fetching URLs..."
    @Binding var installInfo: InstallAssistant?
    @State var downloadProgress: CGFloat = 0
    @State var buttonBG = Color.accentColor
    @State var buttonBG2 = Color.accentColor
    @State var invalidPassword = false
    @Binding var password: String
    @Binding var p: Int
    @Binding var overrideInstaller: Bool
    @Binding var track: ReleaseTrack
    @State var currentSize = 10
    @State var downloadSize = 1000
    @Binding var useCurrent: Bool
    @Binding var package: String
    @Binding var installer: String?
    let timer = Timer.publish(every: 2, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Download Install Assistant Package").bold()
            Text("The Install Assistant is the file that contains the macOS installer used to install macOS. In our case, we can't just use the app. Later on, we need to use the createinstallmedia tool to create an installer USB. This USB drive has to be patched, so it will let us boot into it. Simple enough, right? Note: This download will take a while.")
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
                            if installInfo != nil {
                                downloadStatus = "Download macOS \(installInfo!.version)"
                                return
                            } else if package != "~/.patched-sur/InstallAssistant.pkg" {
                                useCurrent = true
                                downloadStatus = "Use Pre-Downloaded Package"
                                return
                            } else if installer != nil {
                                useCurrent = true
                                downloadStatus = "Use Pre-Downloaded Installer App"
                                return
                            }
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    let allInstallInfo = try InstallAssistants(data: try Data(contentsOf: URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : (track == .publicbeta ? "Public" : "Release")).json")!))
                                    installInfo = allInstallInfo.filter({ (installer) -> Bool in
                                        if installer.minVersion > AppInfo.build {
                                            return false
                                        }
                                        return true
                                    }).sorted(by: { (one, two) -> Bool in
                                        if one.orderNumber > two.orderNumber {
                                            return true
                                        }
                                        return false
                                    })[0]
                                    if (try? InstallAssistant(try File(path: "~/.patched-sur/InstallInfo.txt").readAsString()))?.version == installInfo?.version {
                                        useCurrent = true
                                        downloadStatus = "Download macOS \(installInfo!.version)"
                                        return
                                    }
                                    downloadStatus = "Download macOS \(installInfo!.version)"
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                        .padding(6)
                        .padding(.horizontal, 4)
                } else if downloadStatus.hasPrefix("Download macOS") {
                    VStack {
                        HStack {
                            Button {
                                if !useCurrent {
                                    if let sizeString = try? call("curl -sI \(installInfo!.url) | grep -i Content-Length | awk '{print $2}'") {
                                        let sizeStrings = sizeString.split(separator: "\r\n")
                                        print(sizeStrings)
                                        if sizeStrings.count > 0, let sizeInt = Int(sizeStrings[0]) {
                                            downloadSize = sizeInt
                                        }
                                    }
                                    downloadStatus = downloadStatus.replacingOccurrences(of: "Download", with: "Downloading") + "..."
                                } else {
                                    downloadStatus = ""
                                }
                                buttonBG = Color.accentColor
                            } label: {
                                ZStack {
                                    buttonBG
                                        .cornerRadius(10)
                                    if package == "~/.patched-sur/InstallAssistant.pkg" && installer == nil {
                                        Text("\(useCurrent ? "Use" : "Download") macOS \(installInfo!.version)")
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .padding(.horizontal, 4)
                                    } else if package != "~/.patched-sur/InstallAssistant.pkg" {
                                        Text("Use Pre-Downloaded InstallAssistant")
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .padding(.horizontal, 4)
                                    } else {
                                        Text("Use Pre-Downloaded Installer App")
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .padding(.horizontal, 4)
                                    }
                                }
                                .onHover { (hovering) in
                                    if useCurrent || package != "~/.patched-sur/InstallAssistant.pkg" {
                                        buttonBG = hovering ? Color.green.opacity(0.7) : Color.green
                                    } else {
                                        buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                                    }
                                }
                                .onAppear {
                                    buttonBG = useCurrent ? Color.green : Color.accentColor
                                }
                                
                            }.buttonStyle(BorderlessButtonStyle())
                            if package == "~/.patched-sur/InstallAssistant.pkg" && installer == nil && useCurrent {
                                Button {
                                    if let sizeString = try? call("curl -sI \(installInfo!.url) | grep -i Content-Length | awk '{print $2}'") {
                                        let sizeStrings = sizeString.split(separator: "\n")
                                        if sizeStrings.count > 0, let sizeInt = Int(sizeStrings[0]) {
                                            downloadSize = sizeInt
                                        }
                                    }
                                    downloadStatus = downloadStatus.replacingOccurrences(of: "Download", with: "Downloading") + "..."
                                    buttonBG = Color.accentColor
                                } label: {
                                    ZStack {
                                        buttonBG2
                                            .cornerRadius(10)
                                        Text("Redownload")
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .padding(.horizontal, 4)
                                    }
                                }.buttonStyle(BorderlessButtonStyle())
                                .onHover { (hovering) in
                                    buttonBG2 = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                                }
                            }
                        }
                        Button {
                            withAnimation {
                                p = 11
                            }
                        } label: {
                            Text("View Other Versions")
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                } else if downloadStatus.hasPrefix("Downloading macOS ") {
                    VStack {
                        ZStack {
                            ProgressBar(value: $downloadProgress)
                                .onReceive(timer, perform: { _ in
                                    DispatchQueue.global(qos: .background).async {
                                        if let sizeCode = try? call("stat -f %z ~/.patched-sur/InstallAssistant.pkg") {
                                            currentSize = Int(Float(sizeCode) ?? 10000)
                                            downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
                                        }
                                    }
                                })
                            Text(downloadStatus)
                                .foregroundColor(.white)
                                .lineLimit(5)
                                .padding(6)
                                .padding(.horizontal, 4)
                                .onAppear {
                                    DispatchQueue.global(qos: .background).async {
                                        _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
                                        do {
                                            let reasonForActivity = "Reason for activity" as CFString
                                            var assertionID: IOPMAssertionID = 0
                                            var success = IOPMAssertionCreateWithName( kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                                                        IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                                                        reasonForActivity,
                                                                                        &assertionID )
                                            if success == kIOReturnSuccess {
                                                try call("curl -L -o InstallAssistant.pkg \(installInfo!.url)", at: "~/.patched-sur")
                                                success = IOPMAssertionRelease(assertionID)
                                            } else {
                                                try call("curl -L -o InstallAssistant.pkg \(installInfo!.url)", at: "~/.patched-sur")
                                            }
                                            let versionFile = try Folder(path: "~/.patched-sur").createFileIfNeeded(at: "InstallInfo.txt")
                                            try versionFile.write(installInfo!.jsonString()!, encoding: .utf8)
                                            buttonBG = .accentColor
                                            downloadStatus = ""
                                        } catch {
                                            downloadStatus = error.localizedDescription
                                        }
                                    }
                                }
                        }
                    }
                } else if downloadStatus == "" {
                    HStack {
                        ZStack {
                            Color.secondary
                                .cornerRadius(10)
                                .frame(width: 300)
                                .opacity(0.7)
                            SecureField("Enter password to continue...", text: $password)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .padding(6)
                                .padding(.horizontal, 4)
                                .disabled(false)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .colorScheme(.dark)
                                .onAppear {
                                    buttonBG = Color.accentColor
                                }
                        }
                        Button {
                            if password != "" {
                                do {
                                    try call("echo Hi", p: password)
                                    if installer != nil {
                                        withAnimation {
                                            p = 5
                                        }
                                    } else {
                                        downloadStatus = "Installing Package..."
                                    }
                                } catch {
                                    invalidPassword = true
                                    password = ""
                                }
                            }
                        } label: {
                            ZStack {
                                buttonBG
                                    .cornerRadius(10)
                                    .onHover(perform: { hovering in
                                        if !(password == "") {
                                            if invalidPassword {
                                                buttonBG = hovering ? Color.red.opacity(0.7) : Color.red
                                            } else {
                                                buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                                            }
                                        }
                                    })
                                Text("Continue")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.top, 10)
                        .opacity(password == "" ? 0.4 : 1)
                    }
                } else if downloadStatus == "Installing Package..." {
                    Color.secondary
                        .cornerRadius(10)
                    Text("Installing Package...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    if package == "~/.patched-sur/InstallAssistant.pkg" {
                                        try call("installer -pkg ~/.patched-sur/InstallAssistant.pkg -target /", p: password)
                                    } else {
                                        try call("installer -pkg \"\(package)\" -target /", p: password)
                                    }
                                    _ = try? call("echo \"\(track)\" > ~/.patched-sur/track.txt")
                                    withAnimation {
                                        p = 5
                                    }
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                } else {
                    VStack {
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
                                    .lineLimit(4)
                                    .padding(6)
                                    .padding(.horizontal, 4)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                        Text("Click to Copy")
                            .font(.caption)
                    }
                }
            }
            .fixedSize()
        }
    }
}

struct ProgressBar: View {
    @Binding var value: CGFloat
    var length: CGFloat = 285
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(minWidth: length)
                .opacity(0.3)
                .foregroundColor(Color.accentColor.opacity(0.3))
            
            Rectangle().frame(width: min(value*length, length))
                .foregroundColor(.accentColor)
                .animation(.linear)
        }.cornerRadius(10)
    }
}
