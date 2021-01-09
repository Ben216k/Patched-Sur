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
    var body: some View {
        VStack {
            Rectangle().foregroundColor(.clear).frame(height: 10)
            if installInfo?.buildNumber != .some(buildNumber) {
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
                TextAndButtonView(t: "Start", b: "Update") {
                    p = 3
                }
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
                NSWorkspace.shared.open(URL(string: "https://developer.apple.com/documentation/macos-release-notes/macos-big-sur-\(versionPieces[0].replacingOccurrences(of: ".", with: "_"))\(versionPieces.contains("Beta") || versionPieces.contains("RC") ? "-beta" : "")-release-notes")!)
            }.font(.caption)
            ZStack {
                Rectangle()
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
                HStack(spacing: 0) {
                    Text("Release Track")
                        .padding(6)
                        .padding(.leading, 4)
                        .foregroundColor(.white)
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
                            do {
                                try shellOut(to: "echo '\(releaseTrack != .release ? "Release" : (releaseTrack != .publicbeta ? "Public Beta" : "Developer"))' > ~/.patched-sur/track.txt")
                                showMoreTracks = false
                                releaseTrack = releaseTrack != .release ? .release : (releaseTrack != .publicbeta ? .publicbeta : .developer)
                                p = 0
                            } catch {
                                showMoreTracks = false
                                let errorAlert = NSAlert()
                                errorAlert.alertStyle = .critical
                                errorAlert.informativeText = error.localizedDescription
                                errorAlert.messageText = "Unable to Switch Release Track"
                                errorAlert.runModal()
                            }
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
                            do {
                                try shellOut(to: "echo '\(releaseTrack != .developer ? "Developer" : (releaseTrack != .publicbeta ? "Public Beta" : "Release"))' > ~/.patched-sur/track.txt")
                                showMoreTracks = false
                                releaseTrack = releaseTrack != .developer ? .developer : (releaseTrack != .publicbeta ? .publicbeta : .release)
                                p = 0
                            } catch {
                                showMoreTracks = false
                                let errorAlert = NSAlert()
                                errorAlert.alertStyle = .critical
                                errorAlert.informativeText = error.localizedDescription
                                errorAlert.messageText = "Unable to Switch Release Track"
                                errorAlert.runModal()
                            }
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
            
            TextAndButtonView(t: "View Other", b: "macOS Versions") {
                
            }.font(.caption)

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
        }
    }
}
