//
//  CreateInstallerView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import VeliaUI

struct CreateInstallerView: View {
    @Binding var p: PSPage
    @State var errorX = "EXTRACT"
    @Binding var password: String
    @Binding var showPass: Bool
    @State var hovered: String?
    @State var progressText = ""
    @Binding var volume: String
    @Binding var installInfo: InstallAssistant?
    @State var isBeta = ""
    @Binding var onExit: () -> (BackMode)
    @State var alert: Alert?
    
    var body: some View {
        VStack {
            Text("Creating USB Installer")
                .font(.system(size: 15)).bold()
            Text("Now the USB you selected is being used to create a macOS installer USB. The files copied on the disk create an environment similar to macOS Big Sur Recovery Mode. Once those files are placed on the USB, Patched Sur steps in and patches it allowing for your Mac to boot into it and giving it some useful tools for a patched Mac.")
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            if password == "" || showPass {
                VIButton(id: "REQUEST-ROOT", h: $hovered) {
                    Text("Request Root Permissions")
                } onClick: {
                    withAnimation {
                        showPass = true
                    }
                }.inPad()
                .onAppear {
                    withAnimation(Animation.default.delay(0.25)) {
                        showPass = true
                        
                    }
                }.animation(.none)
            } else if errorX == "EXTRACT" {
                VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                    Image("PackageCircle")
                    Text("Extracting Package")
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    onExit = {
                        let al = NSAlert()
                        al.informativeText = "Are you sure you want to cancel making the patched macOS installer? You will need this to upgrade to macOS Big Sur, and it often takes a long time to make."
                        al.messageText = "A macOS Installer is Being Made"
                        al.showsHelp = false
                        al.addButton(withTitle: "Cancel Process")
                        al.addButton(withTitle: "Restart Process")
                        al.addButton(withTitle: "Continue Process")
                        switch al.runModal() {
                        case .alertFirstButtonReturn:
                            _ = try? call("killall bash")
                            return .confirm
                        case .alertSecondButtonReturn:
                            _ = try? call("killall bash")
                            _ = try? call("sleep 0.25")
                            errorX = "EXTRACT"
                            return .cancel
                        default:
                            return .cancel
                        }
                    }
                    DispatchQueue(label: "ExtractPackage").async {
                        extractPackage(installInfo: installInfo!, password: password, errorX: {
                            errorX = $0
                            DispatchQueue.main.async {
                                if errorX != "CREATE" {
                                    onExit = {
                                        let al = NSAlert()
                                        al.informativeText = "There was an error while creating the macOS installer USB, however you may want to try again to possibly fix this error."
                                        al.messageText = "Would you like to try again?"
                                        al.showsHelp = false
                                        al.addButton(withTitle: "Restart Process")
                                        al.addButton(withTitle: "Go Back")
                                        al.addButton(withTitle: "Cancel")
                                        switch al.runModal() {
                                        case .alertFirstButtonReturn:
                                            errorX = "EXTRACT"
                                            return .cancel
                                        case .alertSecondButtonReturn:
                                            return .confirm
                                        default:
                                            return .cancel
                                        }
                                    }
                                }
                            }
                        }, beta: { isBeta = $0 })
                    }
                }
            } else if errorX == "CREATE" {
                VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                    Image("DriveCircle")
                    Text("Creating Installer")
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    DispatchQueue(label: "CreateInstaller").async {
                        createInstallMedia(volume: volume, installInfo: installInfo!, password: password, progressText: { progressText = $0 }, errorX: {
                            errorX = $0
                            if errorX != "PATCH" {
                                DispatchQueue.main.async {
                                    onExit = {
                                        let al = NSAlert()
                                        al.informativeText = "There was an error while creating the macOS installer USB, however you may want to try again to possibly fix this error."
                                        al.messageText = "Would you like to try again?"
                                        al.showsHelp = false
                                        al.addButton(withTitle: "Restart Process")
                                        al.addButton(withTitle: "Go Back")
                                        al.addButton(withTitle: "Cancel")
                                        switch al.runModal() {
                                        case .alertFirstButtonReturn:
                                            errorX = "EXTRACT"
                                            return .cancel
                                        case .alertSecondButtonReturn:
                                            return .confirm
                                        default:
                                            return .cancel
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
                Text(progressText)
                    .font(.caption)
                    .lineLimit(2)
            } else if errorX == "PATCH" {
                VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                    Image("ToolsCircle")
                    Text("Patching Installer")
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    DispatchQueue(label: "PatchKexts").async {
                        patchInstaller(password: password, progressText: { progressText = $0 }, errorX: {
                            errorX = $0
                            DispatchQueue.main.async {
                                if errorX != "DONE" {
                                    onExit = {
                                        let al = NSAlert()
                                        al.informativeText = "There was an error while creating the macOS installer USB, however you may want to try again to possibly fix this error."
                                        al.messageText = "Would you like to try again?"
                                        al.showsHelp = false
                                        al.addButton(withTitle: "Restart Process")
                                        al.addButton(withTitle: "Go Back")
                                        al.addButton(withTitle: "Cancel")
                                        switch al.runModal() {
                                        case .alertFirstButtonReturn:
                                            errorX = "EXTRACT"
                                            return .cancel
                                        case .alertSecondButtonReturn:
                                            return .confirm
                                        default:
                                            return .cancel
                                        }
                                    }
                                }
                            }
                        })
                    }
                }
                Text(progressText)
                    .font(.caption)
                    .lineLimit(2)
            } else if errorX == "DONE" {
                Text("Done!")
                    .bold()
                    .onAppear {
                        withAnimation {
                            onExit = { .confirm }
                            p = .done
                        }
                    }
            } else {
                VIError(errorX)
            }
        }
    }
}
