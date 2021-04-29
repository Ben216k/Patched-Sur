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
            Text(.init("PRE-CTI-TITLE"))
                .font(.system(size: 15)).bold()
            Text(.init("PRE-CTI-DESCRIPTION"))
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            if password == "" || showPass {
                VIButton(id: "REQUEST-ROOT", h: $hovered) {
                    Text(.init("REQUEST-ROOT"))
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
                    Text(.init("EXTRACT-PACKAGE"))
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    onExit = {
                        let al = NSAlert()
                        al.informativeText = NSLocalizedString("PRE-CTI-CANCEL-1", comment: "PRE-CTI-CANCEL-1")
                        al.messageText = NSLocalizedString("PRE-CTI-CANCEL-2", comment: "PRE-CTI-CANCEL-2")
                        al.showsHelp = false
                        al.addButton(withTitle: NSLocalizedString("CANCEL-PROCESS", comment: "CANCEL-PROCESS"))
                        al.addButton(withTitle: NSLocalizedString("RESTART-PROCESS", comment: "RESTART-PROCESS"))
                        al.addButton(withTitle: NSLocalizedString("CONTINUE-PROCESS", comment: "CONTINUE-PROCESS"))
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
                                        al.informativeText = NSLocalizedString("PRE-CTI-CANCEL-3", comment: "PRE-CTI-CANCEL-3")
                                        al.messageText = NSLocalizedString("PRE-CTI-CANCEL-4", comment: "PRE-CTI-CANCEL-4")
                                        al.showsHelp = false
                                        al.addButton(withTitle: NSLocalizedString("RESTART-PROCESS", comment: "RESTART-PROCESS"))
                                        al.addButton(withTitle: NSLocalizedString("GO-BACK", comment: "GO-BACK"))
                                        al.addButton(withTitle: NSLocalizedString("CANCEL", comment: "CANCEL"))
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
                    Text(.init("PRE-CTI-CREATING"))
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
                                        al.informativeText = NSLocalizedString("PRE-CTI-CANCEL-3", comment: "PRE-CTI-CANCEL-3")
                                        al.messageText = NSLocalizedString("PRE-CTI-CANCEL-4", comment: "PRE-CTI-CANCEL-4")
                                        al.showsHelp = false
                                        al.addButton(withTitle: NSLocalizedString("RESTART-PROCESS", comment: "RESTART-PROCESS"))
                                        al.addButton(withTitle: NSLocalizedString("GO-BACK", comment: "GO-BACK"))
                                        al.addButton(withTitle: NSLocalizedString("CANCEL", comment: "CANCEL"))
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
                                        al.informativeText = NSLocalizedString("PRE-CTI-CANCEL-3", comment: "PRE-CTI-CANCEL-3")
                                        al.messageText = NSLocalizedString("PRE-CTI-CANCEL-4", comment: "PRE-CTI-CANCEL-4")
                                        al.showsHelp = false
                                        al.addButton(withTitle: NSLocalizedString("RESTART-PROCESS", comment: "RESTART-PROCESS"))
                                        al.addButton(withTitle: NSLocalizedString("GO-BACK", comment: "GO-BACK"))
                                        al.addButton(withTitle: NSLocalizedString("CANCEL", comment: "CANCEL"))
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
