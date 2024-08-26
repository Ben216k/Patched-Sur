//
//  BuildPatchingView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import VeliaUI

struct BuildPatchInstallerView: View {
    @Binding var installInfo: InstallAssistant?
    @Binding var volume: String
    @State var errorX: String = "PACKAGE"
    @Binding var password: String
    @State var progressText = ""
    @Binding var p: ContentView.PIPages
    
    var body: some View {
        VStack {
            Spacer()
            Text("Creating Installer USB")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            if errorX != "CREATE" && errorX != "PACKAGE" && errorX != "PATCH" {
                ErrorHandlingView(bubble: "An error occured attempting to create the macOS installer USB. This could be due to a variaty of issues occuring at different stages during the process.", fullError: errorX)
            } else {
                Text("Patched Sur is now ereasing your USB, copying the macOS installer, then patching it to contain resources for the patcher. This installer USB will contain all of the features of macOS recovery, but focus on Patched Sur. This could take a while depending on the speed of your USB.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                if errorX == "CREATE" {
                    VIButton(id: "nil", h: .constant("null")) {
                        Image("DriveCircle")
                        Text("Creating USB Installer")
                    }.inPad().btColor(.gray).onAppear {
                        DispatchQueue(label: "CreateInstaller").async {
                            createInstallMedia(volume: volume, installInfo: installInfo!, password: password, progressText: { progressText = $0 }, errorX: {
                                errorX = $0
                            })
                        }
                    }
                    Text(progressText)
                        .font(.caption)
                } else if errorX == "PACKAGE" {
                    VIButton(id: "nil", h: .constant("null")) {
                        Image("PackageCircle")
                        Text("Extacting Package")
                    }.inPad().btColor(.gray).onAppear {
                        DispatchQueue(label: "ExtractPackage").async {
                            extractPackage(installInfo: installInfo!, password: password, errorX: { errorX = $0 })
                        }
                    }
                } else if errorX == "PATCH" {
                    VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                        Image("ToolsCircle")
                        Text("Patching Installer")
                    }.inPad().btColor(.gray).onAppear {
                        patchInstaller(password: password, progressText: { progressText = $0 }, errorX: {
                            errorX = $0
                        })
                    }
                    Text(progressText)
                        .font(.caption)
                } else if errorX == "DONE" {
                    Text("Done!")
                        .bold()
                        .onAppear {
                            withAnimation {
                                p = .done
                            }
                        }
                }
            }
            Spacer()
        }
    }
}
