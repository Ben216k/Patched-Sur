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
                Text(.init("PO-UP-USING-TRACK"))
                VIButton(id: "RELEASETRACK", h: $hovered) {
                    Text(releaseTrack == .developer ? .init("TRACK-BETA") : .init("TRACK-RELEASE"))
                } onClick: {
                    UserDefaults.standard.setValue(releaseTrack == .developer ? "Release" : "Developer", forKey: "UpdateTrack")
                    releaseTrack = releaseTrack == .developer ? .release : .developer
                    withAnimation {
                        p = 0
                    }
                }.inPad()
                .padding(.vertical, -5)
                Text(.init(.init("PO-UP-USING-TRACK-2")))
                    .padding(.bottom, -2.5)
                Text(releaseTrack.rawValue == "Developer" ? .init("PO-UP-BETA-DESCRIPTION") : .init("PO-UP-RELEASE-DESCRIPTION"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }.frame(width: 130)
            .font(.caption)
            Group {
                if !configuringNotifis {
                    ScrollView {
                        VStack(alignment: .leading) {
                            if (installInfo!.buildNumber != buildNumber || AppInfo.reinstall) && convertVersionBinary(osVersion) <= convertVersionBinary(installInfo!.version) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.init("PO-UP-IS-AVALIBLE"))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text("macOS Big Sur \(installInfo?.version ?? "v0.0.0")")
                                        .font(.title)
                                        .bold()
                                    Text("\(NSLocalizedString("RELEASED", comment: "RELEASED")) \(installInfo?.localizedDate ?? "0.0.0") • \(NSLocalizedString("BUILD", comment: "BUILD")) \(installInfo?.buildNumber ?? "0.0.0")")
                                        .font(.caption)
                                    Button {
                                        withAnimation {
                                            p = 5
                                        }
                                    } label: {
                                        Text(.init("PO-UP-VIEW-OTHER"))
                                    }.buttonStyle(BorderlessButtonStyle())
                                    .font(.caption)
                                    .padding(.top, 2)
                                }.fixedSize()
                                VIButton(id: "STARTUPDATE", h: $hovered) {
                                    Text(.init("PO-UP-START-TITLE"))
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
                                Text(.init("PO-UP-START-DESCRIPTION"))
                                    .font(.caption)
                                VIButton(id: "NOTES", h: $hovered) {
                                    Text(.init("PO-UP-NOTES-TITLE"))
                                        .font(.caption)
                                } onClick: {
                                    let versionPieces = installInfo!.version.split(separator: " ")
                                    NSWorkspace.shared.open(URL(string: installInfo!.notes ?? "https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-\(versionPieces[0].replacingOccurrences(of: ".", with: "_"))\(versionPieces.contains("Beta") || versionPieces.contains("RC") ? "-beta" : "")-release-notes")!)
                                }.inPad()
                                .padding(.bottom, -7.5)
                                Text(.init("PO-UP-NOTES-DESCRIPTION"))
                                    .font(.caption)
                            } else {
                                VStack(alignment: .leading, spacing: 0) {
            //                        Text("An update is available!")
            //                            .font(.headline)
            //                            .fontWeight(.semibold)
                                    Text(.init("PO-UP-NO-UPDATES"))
                                        .font(.title)
                                        .bold()
                                        .padding(.top, 5)
                                    Text(NSLocalizedString("PO-UP-YOU-ON", comment: "PO-UP-YOU-ON").replacingOccurrences(of: "XX.YY.ZZ", with: "\(osVersion) (\(buildNumber))"))
                                        .font(.caption)
                                    Button {
                                        withAnimation {
                                            p = 5
                                        }
                                    } label: {
                                        Text(.init("PO-UP-VIEW-OTHER"))
                                    }.buttonStyle(BorderlessButtonStyle())
                                    .font(.caption)
                                    .padding(.top, 2)
                                }.fixedSize()
                                VIButton(id: "NOTES", h: $hovered) {
                                    Text(.init("PO-UP-NOTES-TITLE"))
                                        .font(.caption)
                                } onClick: {
                                    let versionPieces = installInfo!.version.split(separator: " ")
                                    NSWorkspace.shared.open(URL(string: installInfo!.notes ?? "https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-\(versionPieces[0].replacingOccurrences(of: ".", with: "_"))\(versionPieces.contains("Beta") || versionPieces.contains("RC") ? "-beta" : "")-release-notes")!)
                                }.inPad()
                                .padding(.bottom, -7.5)
                                .padding(.top, 5)
                                Text(.init("PO-UP-NOTES-DESCRIPTION"))
                                    .font(.caption)
                            }
                            VIButton(id: "NOTIFIS", h: $hovered) {
                                Text(.init("PO-UP-NOTIF-TITLE"))
                                    .font(.caption)
                            } onClick: {
                                withAnimation {
                                    configuringNotifis = true
                                }
                            }.inPad()
                            .padding(.bottom, -7.5).padding(.top, 5)
                            Text(.init("PO-UP-NOTIF-DESCRIPTION"))
                                .font(.caption)
                            Spacer(minLength: 0)
                        }
                    }.transition(.moveAway2)
                } else {
                    NotificationsView(showNotifis: $configuringNotifis, showPass: $showPass, password: $password)
                }
            }
        }.padding(.top, 10)
    }
}
