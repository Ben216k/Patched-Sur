//
//  macOSConfirmView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/14/21.
//

import VeliaUI
import Files

struct macOSConfirmView: View {
    @Binding var p: PSPage
    @Binding var installInfo: InstallAssistant?
    @State var installers: InstallAssistants = []
    @State var hovered: String?
    @State var errorX = ""
    @Binding var track: ReleaseTrack
    @State var alert: Alert?
    
    var body: some View {
        VStack {
            Text("macOS Big Sur Version")
                .font(.system(size: 15)).bold()
            Text("While in most cases you'll want the latest version of macOS Big Sur, you might for whatever reason want an older version, and you can configure that here. If you want to use a pre-downloaded InstallAssistant.pkg or installer app, you can by clicking browse. If you just want to download and use the latest version of macOS, just click Download.")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            if installers.count > 0 || errorX != "" {
                if errorX != "" {
                    Text("The available macOS installer list could not be accessed. This is probably because WiFi is unavailable. You must use a pre-downloaded macOS installer.")
                        .multilineTextAlignment(.center)
                        .padding(.top, -15)
                        .padding(.bottom, 5)
                }
                if installInfo == nil && installers.count > 0 {
                    VIButton(id: "DOWNLOAD", h: $hovered) {
                        Image("DownloadArrow")
                        Text("Download macOS \(installers[0].version)")
                    } onClick: {
                        installInfo = installers[0]
                        withAnimation {
                            p = .kexts
                        }
                    }.inPad()
                } else if installInfo != nil {
                    HStack {
                        VIButton(id: "USE", h: $hovered) {
                            Image("ForwardArrowCircle")
                            Text("Use macOS \(installInfo?.version ?? "Pre-downloaded")")
                        } onClick: {
                            withAnimation {
                                p = .kexts
                            }
                        }.inPad()
                        .btColor(.init("GreenTint"))
                        if errorX == "" {
                            VIButton(id: "DOWNLOAD", h: $hovered) {
                                Image("DownloadArrow")
                                Text("Redownload")
                            } onClick: {
                                installInfo = installers[0]
                                withAnimation {
                                    p = .kexts
                                }
                            }.inPad()
                        }
                    }
                }
                HStack {
                    VIButton(id: "BROWSE", h: $hovered) {
                        Image("Package")
                        Text("Browse")
                    } onClick: {
                        print("Initializing browse panel")
                        let dialog = NSOpenPanel()

                        dialog.title = "Choose an macOS Big Sur Installer"
                        dialog.showsResizeIndicator = false
                        dialog.allowsMultipleSelection = false
                        dialog.allowedFileTypes = ["app", "pkg"]

                        guard dialog.runModal() == NSApplication.ModalResponse.OK else { print("Browser was canceled"); return }
                        
                        print("Received response")
                        
                        guard let result = dialog.url else { print("There was no result..."); return }
                        let path: String = result.path
                        
                        guard verifyInstaller(alert: &alert, path: path) else { return }
                        
                        print("Saving installInfo")
                        if path.hasSuffix("pkg") {
                            installInfo = .init(url: path, date: "", buildNumber: "CustomPKG", version: "", minVersion: 0, orderNumber: 0, notes: nil)
                        } else if path.hasSuffix("app") {
                            installInfo = .init(url: path, date: "", buildNumber: "CustomAPP", version: "", minVersion: 0, orderNumber: 0, notes: nil)
                        }
                        
                        withAnimation {
                            p = .kexts
                        }
                    }.inPad()
                    .btColor(.gray)
                    .useHoverAccent()
                    ForEach(installers.filter { $0.buildNumber != installers[0].buildNumber }, id: \.buildNumber) { installer in
                        VIButton(id: installer.buildNumber, h: $hovered) {
                            Text(installer.version)
                        } onClick: {
                            alert = .init(title: Text("Patched Sur will use an old version of macOS"), message: Text("Older versions of macOS may be missing security updates and bug fixes. Are you sure you want to use macOS \(installer.version) even though the latest version of macOS is \(installers[0].version)?"), primaryButton: .default(Text("Continue"), action: { installInfo = installer; withAnimation { p = .kexts } }), secondaryButton: .default(Text("Continue")))
                        }.inPad()
                        .btColor(.gray)
                        .useHoverAccent()
                    }
                }
            } else {
                VIButton(id: "SOMETHING", h: .constant("12")) {
                    Image("DownloadArrow")
                    Text("Fetching Installers")
                } onClick: {
                    
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        print("Checking for pre-downloaded installer...")
                        if (try? call("[[ -e ~/.patched-sur/InstallAssistant.pkg ]]")) != nil && ((try? call("[[ -e ~/.patched-sur/InstallInfo.txt ]]")) != nil) {
                            print("Verifying pre-downloaded installer...")
                            var alertX: Alert?
                            guard let installerPath = (try? File(path: "~/.patched-sur/InstallAssistant.pkg"))?.path else { print("Unable to pull installer path"); return }
                            if verifyInstaller(alert: &alertX, path: installerPath), let contents = try? File(path: "~/.patched-sur/InstallInfo.txt").readAsString() {
                                print("Phrasing installer data...")
                                guard let baseInfo = try? InstallAssistant(contents) else { return }
                                installInfo = .init(url: installerPath, date: "", buildNumber: "CustomPKG", version: baseInfo.version, minVersion: 0, orderNumber: 0, notes: nil)
                            }
                        }
                        installers = fetchInstallers(errorX: { errorX = $0 }, track: track)
                        print("Checking if the pre-downloaded installer is recent...")
                        if installers.count > 0 {
                            if installInfo?.version != installers[0].version { installInfo = nil }
                        }
                    }
                }
            }
        }.alert($alert)
    }
}

extension View {
    func alert(_ definition: Binding<Alert?>) -> some View {
        return self
            .alert(
                isPresented: .init(
                    get: { definition.wrappedValue != nil },
                    set: { definition.wrappedValue = $0 ? definition.wrappedValue : nil }),
                content: { definition.wrappedValue ?? Alert(title: Text("Confused")) }
            )
    }
}
