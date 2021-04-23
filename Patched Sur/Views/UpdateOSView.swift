//
//  UpdateOSView.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/7/21.
//

import VeliaUI

struct UpdateOSView: View {
    let installers: InstallAssistants?
    @Binding var installInfo: InstallAssistant?
    @Binding var releaseTrack: ReleaseTrack
    let buildNumber: String
    let osVersion: String
    @State var hovered = nil as String?
    @State var showMoreTracks = false
    @State var showOtherInstallers = false
    @State var customInstaller = nil as String?
    @Binding var p: Int
    @State var configuringNotifis = false
    @State var alert: Alert?
    @Binding var showPass: Bool
    @Binding var password: String
    
    var body: some View {
        HStack(spacing: 30) {
            VStack {
                SideImageView(releaseTrack: releaseTrack.rawValue, scale: 90)
                    .padding(.vertical, -5)
                    .padding(.top, -20)
                Text("You are using the")
                VIButton(id: "RELEASETRACK", h: $hovered) {
                    Text(releaseTrack == .developer ? "Beta" : "Release")
                } onClick: {
                    UserDefaults.standard.setValue(releaseTrack == .developer ? "Release" : "Developer", forKey: "UpdateTrack")
                    releaseTrack = releaseTrack == .developer ? .release : .developer
                    withAnimation {
                        p = 0
                    }
                }.inPad()
                .padding(.vertical, -5)
                Text("update track.")
                    .padding(.bottom, -2.5)
                Text(releaseTrack.rawValue == "Developer" ? "These updates can be unstable and is not always suggested for daily use." : "These updates are normally more stable and is the default update track.")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }.frame(width: 130)
            .font(.caption)
            Group {
                if !configuringNotifis {
                    VStack(alignment: .leading) {
                        if (installInfo!.buildNumber != buildNumber || AppInfo.reinstall) && convertVersionBinary(osVersion) <= convertVersionBinary(installInfo!.version) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("An update is available!")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text("macOS Big Sur \(installInfo?.version ?? "v0.0.0")")
                                    .font(.title)
                                    .bold()
                                Text("Released \(installInfo?.localizedDate ?? "0.0.0") • Build \(installInfo?.buildNumber ?? "0.0.0")")
                                    .font(.caption)
                                Button {
                                    withAnimation {
                                        p = 5
                                    }
                                } label: {
                                    Text("View Other Versions")
                                }.buttonStyle(BorderlessButtonStyle())
                                .font(.caption)
                                .padding(.top, 2)
                            }.fixedSize()
                            VIButton(id: "STARTUPDATE", h: $hovered) {
                                Text("Start the macOS Update")
                                    .font(.caption)
                            } onClick: {
                                checkGeneralUpdateCompat { worked in
                                    if worked {
                                        withAnimation {
                                            p = 3
                                        }
                                        return
                                    }
                                    showPass = true
                                    DispatchQueue.global(qos: .background).async {
                                        while true {
                                            if !showPass && password != "" {
                                                break
                                            }
                                            _ = try? call("sleep 0.2")
                                        }
                                        DispatchQueue.main.async {
                                            AppInfo.canReleaseAttention = false
                                            do {
                                                try call("defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true", p: password)
                                            } catch {
                                                print("Failed to change library validation status.")
                                                presentAlert(m: "Failed to update LV status", i: "Patched Sur was unable to disable library validation.", s: .warning)
                                            }
                                            let al = NSAlert()
                                            al.informativeText = "You now need to reboot your Mac to apply the changes, then you can continue on with the updater."
                                            al.messageText = "Successfully Disabled Library Validation"
                                            al.showsHelp = false
                                            al.addButton(withTitle: "Reboot Mac")
                                            switch al.runModal() {
                                            case .alertFirstButtonReturn:
                                                do {
                                                    try call("reboot", p: password)
                                                } catch {
                                                    print("Failed to reboot, telling the user to do it themself.")
                                                    presentAlert(m: "Failed to Reboot", i: "You can do it yourself! Cmd+Control+Eject (or Cmd+Control+Power if you want it to be faster) will reboot your computer, or you can use the Apple logo in the corner of the screen. Your choice, they all work.", s: .warning)
                                                    AppInfo.canReleaseAttention = true
                                                }
                                            default:
                                                break
                                            }
                                        }
                                    }
                                }
                            }.inPad()
                            .padding(.bottom, -7.5)
                            Text("To update, the patcher will first download the latest patches and then the new version of macOS directly from Apple, and after that Apple’s updater will be started without the compatibility check.")
                                .font(.caption)
                            VIButton(id: "NOTES", h: $hovered) {
                                Text("See the Release Notes")
                                    .font(.caption)
                            } onClick: {
                                let versionPieces = installInfo!.version.split(separator: " ")
                                NSWorkspace.shared.open(URL(string: installInfo!.notes ?? "https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-\(versionPieces[0].replacingOccurrences(of: ".", with: "_"))\(versionPieces.contains("Beta") || versionPieces.contains("RC") ? "-beta" : "")-release-notes")!)
                            }.inPad()
                            .padding(.bottom, -7.5)
                            Text("See what’s new in macOS before updating. Thanks to Mr. Macintosh (or Apple sometimes) for providing these.")
                                .font(.caption)
                        } else {
                            VStack(alignment: .leading, spacing: 0) {
        //                        Text("An update is available!")
        //                            .font(.headline)
        //                            .fontWeight(.semibold)
                                Text("No new updates available.")
                                    .font(.title)
                                    .bold()
                                    .padding(.top, 5)
                                Text("You're currently on \(osVersion) (\(buildNumber))")
                                    .font(.caption)
                                Button {
                                    withAnimation {
                                        p = 5
                                    }
                                } label: {
                                    Text("View Other Versions")
                                }.buttonStyle(BorderlessButtonStyle())
                                .font(.caption)
                                .padding(.top, 2)
                            }.fixedSize()
                            VIButton(id: "NOTES", h: $hovered) {
                                Text("See the \(installInfo!.version) Release Notes")
                                    .font(.caption)
                            } onClick: {
                                let versionPieces = installInfo!.version.split(separator: " ")
                                NSWorkspace.shared.open(URL(string: installInfo!.notes ?? "https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-\(versionPieces[0].replacingOccurrences(of: ".", with: "_"))\(versionPieces.contains("Beta") || versionPieces.contains("RC") ? "-beta" : "")-release-notes")!)
                            }.inPad()
                            .padding(.bottom, -7.5)
                            .padding(.top, 5)
                            Text("See what’s new in the current macOS version you're on. Thanks to Mr. Macintosh (or Apple sometimes) for providing these.")
                                .font(.caption)
                        }
                        VIButton(id: "NOTIFIS", h: $hovered) {
                            Text("Configure Update Notifications")
                                .font(.caption)
                        } onClick: {
                            withAnimation {
                                configuringNotifis = true
                            }
                        }.inPad()
                        .padding(.bottom, -7.5).padding(.top, 5)
                        Text("Get notifications for updates for both macOS and the patcher.")
                            .font(.caption)
                        Spacer(minLength: 0)
                    }.transition(.moveAway2)
                } else {
                    NotificationsView(showNotifis: $configuringNotifis, showPass: $showPass, password: $password)
                }
            }
        }.padding(.top, 10)
    }
}
