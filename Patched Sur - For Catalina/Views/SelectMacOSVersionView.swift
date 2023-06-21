//
//  SelectMacOSVersionView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import VeliaUI
import OSLog

struct SelectMacOSVersionView: View {
    @Binding var installInfo: InstallAssistant?
    @Binding var installAssistants: [InstallAssistant]
    @State var hovered: String?
    @State var alert: Alert?
    
    var body: some View {
        VStack {
            Text("Advanced: Select macOS Version")
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 10)
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Use Local Installer")
                            .font(.system(size: 13)).bold()
//                                .padding(.bottom, 0.01)
                        Text("For if you downloaded your own installer for macOS Big Sur (App or PKG)")
                            .font(.system(size: 13))
                            .lineLimit(1)
                    }
                    Spacer()
                    VIButton(id: "local", h: "local" == installInfo?.buildNumber ? .constant("local") : $hovered) {
                        Text("local" == installInfo?.buildNumber ? "Selected" : "Browse")
                    } onClick: {
                        OSLog.verification.log("Initializing browse panel")
                        let dialog = NSOpenPanel()

                        dialog.title = "Choose an macOS Big Sur Installer"
                        dialog.showsResizeIndicator = false
                        dialog.allowsMultipleSelection = false
                        dialog.allowedFileTypes = ["app", "pkg"]

                        guard dialog.runModal() == NSApplication.ModalResponse.OK else { print("Browser was canceled"); return }
                        
                        OSLog.verification.log("User selected installer")
                        
                        guard let result = dialog.url else { print("There was no result..."); return }
                        let path: String = result.path
                        
                        guard verifyInstaller(alert: &alert, path: path) else { return }
                        
                        OSLog.verification.log("Saving installInfo")
                        if path.hasSuffix("pkg") {
                            installInfo = .init(url: path, date: "", buildNumber: "local", version: "CustomPKG", minVersion: 0, orderNumber: 0, notes: nil)
                        } else if path.hasSuffix("app") {
                            installInfo = .init(url: path, date: "", buildNumber: "local", version: "CustomAPP", minVersion: 0, orderNumber: 0, notes: nil)
                        }
                    }.inPad()
                }.padding(.horizontal).alert(isPresented: .init(get: { alert != nil }, set: { _ in alert = nil })) {
                    alert ?? Alert(title: Text("Unable to Use Package"), message: Text("Something went wrong, and an error cannot be provided."))
                }
                Divider().padding(.horizontal)
                ForEach(installAssistants, id: \.buildNumber) { installer in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("macOS Big Sur \(installer.version)")
                                .font(.system(size: 13)).bold()
//                                .padding(.bottom, 0.01)
                            Text("Build \(installer.buildNumber) - Released \(installer.localizedDate)")
                                .font(.system(size: 13))
                        }
                        Spacer()
                        VIButton(id: installer.buildNumber, h: installer.buildNumber == installInfo?.buildNumber ? .constant(installer.buildNumber) : $hovered) {
                            Text(installer.buildNumber == installInfo?.buildNumber ? "Selected" : "Select")
                        } onClick: {
                            withAnimation { installInfo = installer }
                        }.inPad()
                    }
                    Divider()
                }.padding(.horizontal)
            }
        }
    }
}
