//
//  UpdateStatusView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/28/20.
//

import SwiftUI

struct UpdateStatusView: View {
    let installers: InstallAssistants?
    @Binding var installInfo: InstallAssistant?
    @Binding var releaseTrack: ReleaseTrack
    let buildNumber: String
    @State var hovered = nil as String?
    @State var showMoreTracks = false
    @State var showOtherInstallers = false
    @State var customInstaller = nil as String?
    @Binding var p: Int
    @State var alert: Alert?
    var body: some View {
        VStack {
            Rectangle().foregroundColor(.clear).frame(height: 10)
            if installInfo?.buildNumber != .some(buildNumber) || AppInfo.reinstall {
                HStack(spacing: 0) {
                    SideImageView(releaseTrack: releaseTrack.rawValue, scale: 60)
                    VStack(alignment: .leading) {
                        Text("An update is available!")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("macOS Big Sur \(installInfo?.version ?? "v0.0.0")")
                            .font(.title)
                            .bold()
                        Text("Released \(installInfo?.date ?? "0.0.0") • Build \(installInfo?.buildNumber ?? "0.0.0")")
                            .font(.caption)
                    }
                }
                TextAndButtonView(t: "Start the", b: "macOS Update!") {
                    print("Check for AMFI...")
                    var bootargs = ""
                    do {
                        bootargs = try call("nvram boot-args")
                    } catch {
                        print("Failed to check boot args. This is unexpected, and should be impossible.")
                        presentAlert(m: "Failed to check boot-args.", i: "Patched Sur failed to check your boot args, which should be impossible. If the boot-args value did not exist, you wouldn't be able to boot macOS, so that couldn't be an issue.\n\n\(error.localizedDescription)")
                        return
                    }
                    bootargs.removeFirst("boot-args    ".count)
                    if bootargs.contains("amfi_get_out_of_my_way=1") {
                        print("AMFI is off, continuing...")
                        p = 7
                    } else {
                        print("AMFI is not set, warning user.")
                        alert = .init(title: Text("AMFI Appears to Be On"), message: Text("Since the installer checks to see if the update supports your Mac, Patched Sur needs to inject a dylib into it so that the installer doesn't care about the incompatibilty. However, this can only be done with AMFI off, so Patched Sur will quickly turn this off then restart your Mac, so then you can continue with updating."), primaryButton: .default(Text("Continue"), action: {
                            p = 6
                        }), secondaryButton: .cancel())
                    }
                }.font(Font.caption.bold())
            } else {
                VStack(alignment: .leading) {
                    Text("No updates are available.")
                        .font(.title)
                    Text("Current Build \(buildNumber)")
                        .font(.caption)
                }.padding(.bottom)
            }
            Rectangle().foregroundColor(.clear).frame(height: 0)
            TextAndButtonView(t: "What's New?", b: "Release Notes") {
                let versionPieces = installInfo!.version.split(separator: " ")
                NSWorkspace.shared.open(URL(string: installInfo!.notes ?? "https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-\(versionPieces[0].replacingOccurrences(of: ".", with: "_"))\(versionPieces.contains("Beta") || versionPieces.contains("RC") ? "-beta" : "")-release-notes")!)
            }.font(.caption)
            ZStack {
                Rectangle()
                    .foregroundColor(Color.accentColor.opacity(0.3))
                    .cornerRadius(10)
                HStack(spacing: 0) {
                    Text("Update Track")
                        .padding(6)
                        .padding(.leading, 4)
                    Button {
                        withAnimation {
                            showMoreTracks.toggle()
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "RELEASE-TRACK" ? .accentColor : Color.accentColor.opacity(0.7))
                                .cornerRadius(10)
                            Text(releaseTrack.rawValue)
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "RELEASE-TRACK" : nil
                    }
                    if showMoreTracks {
                        Button {
                            UserDefaults.standard.setValue(releaseTrack != .release ? "Release" : (releaseTrack != .publicbeta ? "Public Beta" : "Developer"), forKey: "UpdateTrack")
                            showMoreTracks = false
                            releaseTrack = releaseTrack != .release ? .release : (releaseTrack != .publicbeta ? .publicbeta : .developer)
                            p = 0
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(hovered != "RELEASE-TRACK-2" ? .accentColor : Color.accentColor.opacity(0.7))
                                    .cornerRadius(10)
                                Text(releaseTrack != .release ? "Release" : (releaseTrack != .publicbeta ? "Public Beta" : "Developer"))
                                    .padding(6)
                                    .padding(.horizontal, 4)
                                    .foregroundColor(.white)
                            }.fixedSize()
                        }.buttonStyle(BorderlessButtonStyle())
                        .onHover {
                            hovered = $0 ? "RELEASE-TRACK-2" : nil
                        }
                        .padding(.horizontal, 5)
                        Button {
                            UserDefaults.standard.setValue(releaseTrack != .developer ? "Developer" : (releaseTrack != .publicbeta ? "Public Beta" : "Release"), forKey: "UpdateTrack")
                            showMoreTracks = false
                            releaseTrack = releaseTrack != .developer ? .developer : (releaseTrack != .publicbeta ? .publicbeta : .release)
                            p = 0
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(hovered != "RELEASE-TRACK-3" ? .accentColor : Color.accentColor.opacity(0.7))
                                    .cornerRadius(10)
                                Text(releaseTrack != .developer ? "Developer" : (releaseTrack != .publicbeta ? "Public Beta" : "Release"))
                                    .padding(6)
                                    .padding(.horizontal, 4)
                                    .foregroundColor(.white)
                            }.fixedSize()
                        }.buttonStyle(BorderlessButtonStyle())
                        .onHover {
                            hovered = $0 ? "RELEASE-TRACK-3" : nil
                        }
                    }
                }
            }.fixedSize().font(.caption)
            
//            TextAndButtonView(t: "View Other", b: "macOS Versions") {
//
//            }.font(.caption)

//            ZStack {
//                Rectangle()
//                    .foregroundColor(.secondary)
//                    .cornerRadius(10)
//                HStack(spacing: 0) {
//                    Text("Use macOS")
//                        .padding(6)
//                        .padding(.leading, 4)
//                        .foregroundColor(.white)
//                    Button {
//                        withAnimation {
//                            showOtherInstallers.toggle()
//                        }
//                    } label: {
//                        ZStack {
//                            Rectangle()
//                                .foregroundColor(hovered != "OS-LATEST" ? .accentColor : Color.accentColor.opacity(0.7))
//                                .cornerRadius(10)
//                            Text("Latest")
//                                .padding(6)
//                                .padding(.horizontal, 4)
//                                .foregroundColor(.white)
//                        }.fixedSize()
//                    }.buttonStyle(BorderlessButtonStyle())
//                    .onHover {
//                        hovered = $0 ? "OS-LATEST" : nil
//                    }
//                    if showOtherInstallers {
//                        Button {
//                            showOtherInstallers.toggle()
//                        } label: {
//                            ZStack {
//                                Rectangle()
//                                    .foregroundColor(hovered != "OS-REINSTALL" ? .accentColor : Color.accentColor.opacity(0.7))
//                                    .cornerRadius(10)
//                                Text("Reinstall")
//                                    .padding(6)
//                                    .padding(.horizontal, 4)
//                                    .foregroundColor(.white)
//                            }.fixedSize()
//                        }.buttonStyle(BorderlessButtonStyle())
//                        .onHover {
//                            hovered = $0 ? "OS-REINSTALL" : nil
//                        }
//                        .padding(.leading, 5)
//                        Button {
//                            showOtherInstallers.toggle()
//                        } label: {
//                            ZStack {
//                                Rectangle()
//                                    .foregroundColor(hovered != "OS-CUSTOM" ? .accentColor : Color.accentColor.opacity(0.7))
//                                    .cornerRadius(10)
//                                Text("Use My Own")
//                                    .padding(6)
//                                    .padding(.horizontal, 4)
//                                    .foregroundColor(.white)
//                            }.fixedSize()
//                        }.buttonStyle(BorderlessButtonStyle())
//                        .onHover {
//                            hovered = $0 ? "OS-CUSTOM" : nil
//                        }
//                        .padding(.leading, 5)
//                    }
//                }
//            }.fixedSize().font(.caption)
            TextAndButtonView(t: "Configure", b: "Notifications") {
                p = 8
            }.font(.caption)
            TextAndButtonView(t: "Go", b: "Back") {
                p = -1
            }.font(.caption)
        }.alert(isPresented: .init(get: { alert != nil }, set: { _ in
            alert = nil
        }), content: {
            alert!
        })
    }
}
