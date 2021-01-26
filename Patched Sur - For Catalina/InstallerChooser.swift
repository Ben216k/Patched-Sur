//
//  InstallerChooser.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 10/21/20.
//

import SwiftUI
import Files

// MARK: Installer Chooser

struct InstallerChooser: View {
    @Binding var p: Int
    @State var fetchedInstallers: InstallAssistants?
    @Binding var installInfo: InstallAssistant?
    @Binding var track: ReleaseTrack
    @State var current: InstallAssistant?
    @State var errorL: String?
    @State var buttonBG = Color.red
    @State var hovered: String?
    @Binding var useCurrent: Bool
    @Binding var package: String
    @Binding var installer: String?
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text("Installer Chooser").bold()
                    .padding()
                    .onAppear {
                        do {
                            fetchedInstallers = try .init(fromURL: URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : (track == .publicbeta ? "Public" : "Release")).json")!)
                            fetchedInstallers!.sort { $0.orderNumber > $1.orderNumber }
                            current = try? .init(try File(path: "~/.patched-sur/InstallInfo.txt").readAsString())
                        } catch {
                            errorL = error.localizedDescription
                        }
                    }
                ScrollView {
                    if let current = current {
                        InstallerCell(installer: current, hovered: $hovered, installInfo: $installInfo, p: $p, useCurrent: $useCurrent, c: true)
                            .padding(.horizontal)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .padding(.horizontal)
                        .offset(y: -4)
                    if errorL == nil, let fetchedInstallers = fetchedInstallers {
                        ForEach(fetchedInstallers, id: \.version) { installer in
                            InstallerCell(installer: installer, hovered: $hovered, installInfo: $installInfo, p: $p, useCurrent: $useCurrent)
                        }.padding([.bottom, .horizontal])
                    }
                }
                if let error = errorL {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(error, forType: .string)
                    } label: {
                        ZStack {
                            buttonBG
                                .cornerRadius(10)
                                .frame(minWidth: 200, maxWidth: 450)
                                .onHover(perform: { hovering in
                                    buttonBG = hovering ? Color.red.opacity(0.7) : .red
                                })
                            Text(error)
                                .foregroundColor(.white)
                                .lineLimit(4)
                                .padding(6)
                                .padding(.horizontal, 4)
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                    .fixedSize()
                } else if fetchedInstallers == nil {
                    ZStack {
                        Color.secondary
                            .cornerRadius(10)
                            .frame(minWidth: 200, maxWidth: 450)
                        Text("Fetching URLs...")
                            .foregroundColor(.white)
                            .lineLimit(4)
                            .padding(6)
                            .padding(.horizontal, 4)
                    }.fixedSize()
                }
            }
            Button {
                if track == .publicbeta {
                    track = .developer
                } else if track == .release {
                    track = .publicbeta
                } else {
                    track = .release
                }
                DispatchQueue.global(qos: .background).async {
                    let oldInstallers = fetchedInstallers
                    do {
                        fetchedInstallers = try .init(fromURL: URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : (track == .publicbeta ? "Public" : "Release")).json")!)
                        fetchedInstallers!.sort { $0.orderNumber > $1.orderNumber }
                    } catch {
                        if track == .developer {
                            track = .publicbeta
                        } else if track == .publicbeta {
                            track = .release
                        } else {
                            track = .developer
                        }
                        fetchedInstallers = oldInstallers
                        let errorAlert = NSAlert()
                        errorAlert.alertStyle = .critical
                        errorAlert.informativeText = error.localizedDescription
                        errorAlert.messageText = "Unable to Switch Release Track, Error Obtainning New Data"
                        errorAlert.runModal()
                    }
                }
            } label: {
                ZStack {
                    hovered == "CHANGE-TRACK" ? Color.secondary.opacity(0.7).cornerRadius(10) : Color.secondary.cornerRadius(10)
                    Text("\(track == .developer ? "Developer" : (track == .publicbeta ? "Public Beta" : "Release"))")
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .padding(6)
                        .padding(.horizontal, 3)
                }.onHover { hovering in
                    hovered = hovering ? "CHANGE-TRACK" : nil
                }
            }.buttonStyle(BorderlessButtonStyle())
            .fixedSize()
            .padding()
            HStack {
                Button {
                    p = 4
                } label: {
                    ZStack {
                        hovered == "GO-BACK" ? Color.secondary.opacity(0.7).cornerRadius(10) : Color.secondary.cornerRadius(10)
                        Text("Back")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .padding(6)
                            .padding(.horizontal, 3)
                    }.onHover { hovering in
                        hovered = hovering ? "GO-BACK" : nil
                    }
                }.buttonStyle(BorderlessButtonStyle())
                .fixedSize()
                .padding([.vertical, .leading])
                Button {
                    let dialog = NSOpenPanel()

                    dialog.title = "Choose an macOS Big Sur Installer"
                    dialog.showsResizeIndicator = false
                    dialog.allowsMultipleSelection = false
                    dialog.allowedFileTypes = ["app", "pkg"]

                    if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
                        let result = dialog.url

                        if let result = result {
                            let path: String = result.path
                            
                            if path.hasSuffix("pkg") {
                                package = path
                            } else if path.hasSuffix("app") && (try? File(path: "\(path)/Contents/Resources/createinstallmedia")) != nil {
                                installer = path
                            }
                            useCurrent = true
                            p = 4
                        }
                    }
                } label: {
                    ZStack {
                        hovered == "CHOOSE-OTHER" ? Color.secondary.opacity(0.7).cornerRadius(10) : Color.secondary.cornerRadius(10)
                        Text("Browse")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .padding(6)
                            .padding(.horizontal, 3)
                    }.onHover { hovering in
                        hovered = hovering ? "CHOOSE-OTHER" : nil
                    }
                }.buttonStyle(BorderlessButtonStyle())
                .fixedSize()
                .padding([.vertical, .trailing])
                Spacer()
            }
        }
    }
}

// MARK: Installer Cell

struct InstallerCell: View {
    var installer: InstallAssistant
    @Binding var hovered: String?
    @Binding var installInfo: InstallAssistant?
    @Binding var p: Int
    @Binding var useCurrent: Bool
    var c = false
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("macOS \(installer.version)")
                    .fontWeight(.semibold)
                Text("\(installer.buildNumber) - \(installer.date)")
            }
            Spacer()
            Button {
                useCurrent = c
                installInfo = installer
                p = 4
            } label: {
                ZStack {
                    if c {
                        if AppInfo.build >= installer.minVersion {
                            hovered == installer.version + "CI" ? Color.green.opacity(0.7).cornerRadius(10) : Color.green.cornerRadius(10)
                        } else {
                            hovered == installer.version + "CI" ? Color.red.opacity(0.7).cornerRadius(10) : Color.red.cornerRadius(10)
                        }
                    } else {
                        if AppInfo.build >= installer.minVersion {
                            hovered == installer.version ? Color.accentColor.opacity(0.7).cornerRadius(10) : Color.accentColor.cornerRadius(10)
                        } else {
                            hovered == installer.version ? Color.red.opacity(0.7).cornerRadius(10) : Color.red.cornerRadius(10)
                        }
                    }
                    Text(c ? "Downloaded" : "Download")
                        .foregroundColor(.white)
                        .padding(6)
                        .padding(.horizontal, 3)
                }.onHover { hovering in
                    hovered = hovering ? installer.version + (c ? "CI" : "") : nil
                }
            }.buttonStyle(BorderlessButtonStyle())
            .fixedSize()
        }
        .padding(.horizontal, 4)
    }
}
