//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import VeliaUI

struct PSSettings: View {
    @Binding var at: Int
    @State var hovered: String?
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                VIHeader(p: "Extra Settings", s: "Some Useful Tools/Patches")
                    .alignment(.leading)
                Spacer()
                VIButton(id: "BACK", h: $hovered) {
                    Image(systemName: "chevron.backward.circle")
                    Text("Back")
                } onClick: {
                    at = 0
                }.inPad()
            }.padding(.top, 40)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Group {
                        Text("Extra Patches")
                            .font(Font.title3.bold())
                        
                        // MARK: Animations
                        
                        HStack {
                            VIButton(id: "ANI-DISABLE", h: $hovered) {
                                Image(systemName: "dot.circle.and.cursorarrow")
                                Text("Disable Animations")
                            } onClick: {
                                disableAnimations()
                                presentAlert(m: "Disabled Animations!", i: "Once you restart your Mac, the changes will be applied, and Big Sur should preform slightly better.", s: .informational)
                            }.inPad()
                            VIButton(id: "ANI-ENABLE", h: $hovered) {
                                Image(systemName: "cursorarrow.motionlines.click")
                                Text("Enable")
                            } onClick: {
                                enableAnimations()
                                presentAlert(m: "Enabled Animations!", i: "Once you restart your Mac, the changes will be applied.", s: .informational)
                            }.inPad()
                        }
                        Text("Disabling animations can help Macs without Metal. Since they don't have graphics acceleration, Big Sur runs extremely slow, so disabling animations will help a little bit.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 15)
                        
                        // MARK: Graphics Switching
                        
                        HStack {
                            VIButton(id: "GX-ENABLE", h: $hovered) {
                                Image(systemName: "arrow.triangle.swap")
                                Text("Enable Graphics Switching")
                            } onClick: {
                                
                            }.inPad()
                            VIButton(id: "GX-DISABLE", h: $hovered) {
                                Image(systemName: "smallcircle.fill.circle")
                                Text("Disable")
                            } onClick: {
                                
                            }.inPad()
                        }
                        Text("If you have a Mac with mutliple GPUs, then you probably want automatic graphics switching enabled for graphics switching. Thanks to @15wat for finding this solution.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 15)
                    }
                    
                    Group {
                        Text("Extra Tools")
                            .font(Font.title3.bold())
                        
                        // MARK: Patch Kexts Logs
                        
                        VIButton(id: "PATCH-LOGS", h: $hovered) {
                            Image(systemName: "doc.text.below.ecg")
                            Text("Show Patch Kexts Logs")
                        } onClick: {
                            
                        }.inPad()
                        Text("If you're having trouble with Patch Kexts not working, it might be worth seeing the logs and looking for errors. This could help someone trying to help you out figure out the problem, so if you can, provide this to anyone trying to help you.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 15)
                        
                        // MARK: Clean Up Leftovers
                        
                        VIButton(id: "CLEAN-UP", h: $hovered) {
                            Image(systemName: "trash")
                            Text("Clean Up Patched Sur Leftovers")
                        } onClick: {
                            
                        }.inPad()
                        Text("Sometimes, Patched Sur accidentally leaves little leftovers from when something ran. This could at times save 12GB of storage space, this is suggested especially after you run the updater.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 15)
                        
                        // MARK: Contribute Your Experiences
                        
                        VIButton(id: "CONTRIBUTE", h: $hovered) {
                            Image(systemName: "desktopcomputer")
                            Text("Contribute Your Experiences")
                        } onClick: {
                            
                        }.inPad()
                        Text("The preinstall app in Patched Sur has a feature letting new users know how well their Mac will work with Big Sur. However, something like this needs information, and that's what you can help with! Just click on the link above and follow the instructions to help out.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 15)
                    }
                    
                    Rectangle()
                        .foregroundColor(Color.white.opacity(0.000001))
                        .frame(height: 40)
                }.font(.system(size: 11.5))
            }
        }.padding(.horizontal, 30)
    }
}

struct PSOLDSettings: View {
    @State private var showingAlert = false
    let releaseTrack: String
    @Binding var at: Int
    @State var hovered = nil as String?
    @State var password = ""
    @State var showPasswordPrompt = false
    @State var disablingSwitching = false
    @State var showPatchKextsLog = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Patched Sur Settings")
                        .bold()
                        .font(.title)
                    Spacer()
                    if at != -10 {
                        CustomColoredButton("Back to Home", hovered: $hovered) {
                            at = 0
                        }
                    }
                }
                Group {
                    HStack {
                        CustomColoredButton("Disable Animations", hovered: $hovered) {
                            disableAnimations()
                            self.showingAlert = true
                        }
                        CustomColoredButton("Enable Animations", hovered: $hovered) {
                            enableAnimations()
                            self.showingAlert = true
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Changes Made Successfully"), message: Text("A reboot is required to apply these changes."), dismissButton: .default(Text("Okay")))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("Manage Animations. Disabling animations can greatly improve performance on Macs without Metal. A reboot is required to apply these changes.")
                    CustomColoredButton("Contribute Your Experiences", hovered: $hovered) {
                        NSWorkspace.shared.open("https://github.com/BenSova/Patched-Sur-Compatibility")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("The preinstall app in Patched Sur has a new feature letting new users know how well their Mac will work with Big Sur. However, something like this needs information, and that's what you can help with! Just click on the link above and follow the instructions to help out.")
                        .font(.caption)
                    HStack {
                        CustomColoredButton("Enable Graphics Switching", hovered: $hovered) {
                            showPasswordPrompt = true
                            disablingSwitching = false
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        CustomColoredButton("Disable", hovered: $hovered) {
                            showPasswordPrompt = true
                            disablingSwitching = true
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                    .sheet(isPresented: $showPasswordPrompt, content: {
                        ZStack(alignment: .topTrailing) {
                            VStack {
                                HStack {
                                    Text("Patched Sur Requries Your Password to Contninue").bold()
                                        .font(Font.body.bold())
                                    Spacer()
                                    CustomColoredButton("Cancel", hovered: $hovered) {
                                        showPasswordPrompt = false
                                    }
                                }.padding(.bottom)
                                EnterPasswordButton(password: $password) {
                                    if !disablingSwitching {
                                        do {
                                            print("Stopping displaypolicyd...")
                                            _ = try? call("launchctl stop system/com.apple.displaypolicyd", p: password)
                                            print("Enabling Automatic Graphics Switching...")
                                            try call("launchctl disable system/com.apple.displaypolicyd", p: password)
                                            showPasswordPrompt = false
                                            presentAlert(m: "Graphics Switching Enabled", i: "Now graphics will switch automatically! A restart might be required for changes to take effect.", s: .informational)
                                        } catch {
                                            showPasswordPrompt = false
                                            presentAlert(m: "Failed to Enable Graphics Switching", i: error.localizedDescription, s: .critical)
                                        }
                                    } else {
                                        do {
                                            print("Disabling Automatic Graphics Switching...")
                                            try call("launchctl enable system/com.apple.displaypolicyd", p: password)
                                            print("Starting displaypolicyd...")
                                            _ = try? call("launchctl kickstart system/com.apple.displaypolicyd", p: password)
                                            showPasswordPrompt = false
                                            presentAlert(m: "Graphics Switching Disabled", i: "Now graphics will no longer switch automatically! A restart might be required for changes to take effect.", s: .informational)
                                        } catch {
                                            showPasswordPrompt = false
                                            presentAlert(m: "Failed to Diable Graphics Switching", i: error.localizedDescription, s: .critical)
                                        }
                                    }
                                }
                            }
                        }.padding(20)
                    })
                    Text("If you have a Mac with mutliple GPUs, then you probably want automatic graphics switching enabled for graphics switching. Thanks to @15wat for finding this solution.")
                        .font(.caption)
                    CustomColoredButton("Clean Leftovers", hovered: $hovered) {
                        _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
                        _ = try? call("rm -rf ~/.patched-sur/Install\\ macOS Big\\ Sur*.app")
                        _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
                        _ = try? call("rm -rf ~/.patched-sur/trash")
                        presentAlert(m: "Cleaned Leftovers", i: "The files have been deleted, you should see some more free space (assuming that there actually were big files to be cleaned).", s: .informational)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("Sometimes, Patched Sur accidentally leaves little leftovers from when something ran. This could at times save 12GB of storage space, this is suggested especially after you run the updater.")
                        .font(.caption)
                }
                Group {
                    CustomColoredButton("Show Patch Kext Logs", hovered: $hovered) {
                        showPatchKextsLog = true
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("If you're having trouble with Patch Kexts not working, it might be worth seeing the logs and looking for errors. This could help someone trying to help you out figure out the problem, so if you can, provide this to anyone trying to help you")
                        .font(.caption)
                        .sheet(isPresented: $showPatchKextsLog, content: {
                            ZStack(alignment: .topTrailing) {
                                VStack {
                                    HStack {
                                        Text("Patch Kexts Logs").bold()
                                            .font(Font.body.bold())
                                        Spacer()
                                        CustomColoredButton("Close", hovered: $hovered) {
                                            showPatchKextsLog = false
                                        }
                                        if UserDefaults.standard.string(forKey: "PatchKextsLastRun") != nil {
                                            CustomColoredButton("Copy", hovered: $hovered) {
                                                let pasteboard = NSPasteboard.general
                                                pasteboard.declareTypes([.string], owner: nil)
                                                pasteboard.setString(UserDefaults.standard.string(forKey: "PatchKextsLastRun") ?? "No Logs Captured", forType: .string)
                                                presentAlert(m: "Copied!", i: "The last logs from Patch Kexts has been copied to your clipboard. This might help out with debugging, and make sure to share this with anyone trying to help you with your problem.", s: .informational)
                                            }
                                        }
                                    }.padding(.bottom)
                                    ScrollView {
                                        Text(UserDefaults.standard.string(forKey: "PatchKextsLastRun") ?? "No Logs Captured")
                                            .font(.system(size: 11, design: .monospaced))
                                    }
                                }
                            }.padding(20)
                            .frame(width: 580, height: 305)
                        })
                }
                Group {
                    Text("Patched Sur by Ben Sova")
                        .bold()
                        .padding(.top, 5)
                    Text("Thanks to BarryKN, ASentientBot, jackluke, highvoltage12v, ParrotGeek, testheit, Ausdauersportler, StarPlayrX, ASentientHedgehog, John_Val, fromeister2009 and many others!")
                        .font(.caption)
                }
            }.font(.subheadline)
            .padding(.leading, 2)
            .padding(.horizontal, 35)
        }.padding(.vertical, 25)
        .environment(\.releaseTrack, releaseTrack)
    }
}

struct CustomColoredButton: View {
    @Environment(\.releaseTrack) var releaseTrack
    let text: String
    let action: () -> ()
    @Binding var hovered: String?
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(hovered == text ? Color.accentColor.opacity(0.7) : .accentColor)
                Text(text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.horizontal, 4)
            }.fixedSize()
            .cornerRadius(7.5)
        }
        .buttonStyle(BorderlessButtonStyle())
        .onHover {
            hovered = $0 ? text : nil
        }
    }
    
    init(_ text: String, hovered: Binding<String?>, action: @escaping () -> ()) {
        self.text = text
        self.action = action
        self._hovered = hovered
    }
}

extension EnvironmentValues {
    private struct ReleaseTrackKey: EnvironmentKey {
        static let defaultValue = "Release"
    }

    public var releaseTrack: String {
        get {
            self[ReleaseTrackKey]
        } set {
            self[ReleaseTrackKey] = newValue
        }
    }
}
