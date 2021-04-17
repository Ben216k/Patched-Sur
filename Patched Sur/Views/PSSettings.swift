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
    @State var showPassPrompt = false
    @State var passAction: () -> () = {}
    @Binding var password: String
    @State var showKextLogs = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: "Extra Settings", s: "Some Useful Tools/Patches")
                        .alignment(.leading)
                    Spacer()
                    VIButton(id: "BACK", h: $hovered) {
                        Image(systemName: "chevron.backward.circle")
                        Text("Back")
                    } onClick: {
                        withAnimation {
                            at = 0
                        }
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
                                    withAnimation {
                                        showPassPrompt = true
                                    }
                                    passAction = {
                                        enableGxSwitching(p: password)
                                    }
                                }.inPad()
                                VIButton(id: "GX-DISABLE", h: $hovered) {
                                    Image(systemName: "smallcircle.fill.circle")
                                    Text("Disable")
                                } onClick: {
                                    withAnimation {
                                        showPassPrompt = true
                                    }
                                    passAction = {
                                        disableGxSwitching(p: password)
                                    }
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
                                showKextLogs = true
                            }.inPad()
                            .sheet(isPresented: $showKextLogs, content: {
                                VStack {
                                    HStack(spacing: 15) {
                                        VIHeader(p: "Patch Kexts Logs", s: "", c: .constant(true))
                                        Spacer()
                                        if UserDefaults.standard.string(forKey: "PatchKextsLastRun") != nil {
                                            VIButton(id: "LCOPY", h: $hovered) {
                                                Image(systemName: "doc.on.clipboard")
                                            } onClick: {
                                                let pasteboard = NSPasteboard.general
                                                pasteboard.declareTypes([.string], owner: nil)
                                                pasteboard.setString(UserDefaults.standard.string(forKey: "PatchKextsLastRun") ?? "No Logs Captured", forType: .string)
                                                presentAlert(m: "Copied!", i: "The last logs from Patch Kexts has been copied to your clipboard. This might help out with debugging, and make sure to share this with anyone trying to help you with your problem.", s: .informational)
                                            }
                                        }
                                        VIButton(id: "LCLOSE", h: $hovered) {
                                            Image(systemName: "xmark.circle")
                                        } onClick: { showKextLogs = false }
                                    }.padding(.bottom)
                                    ScrollView {
                                        Text(UserDefaults.standard.string(forKey: "PatchKextsLastRun") ?? "No Logs Captured")
                                            .font(.system(size: 11, design: .monospaced))
                                    }
                                }.padding(.horizontal, 30)
                                .padding(.vertical, 20)
                                .frame(width: 580, height: 305)
                            })
                            Text("If you're having trouble with Patch Kexts not working, it might be worth seeing the logs and looking for errors. This could help someone trying to help you out figure out the problem, so if you can, provide this to anyone trying to help you.")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            // MARK: Clean Up Leftovers
                            
                            VIButton(id: "CLEAN-UP", h: $hovered) {
                                Image(systemName: "trash")
                                Text("Clean Up Patched Sur Leftovers")
                            } onClick: {
                                cleanLeftovers()
                            }.inPad()
                            Text("Sometimes, Patched Sur accidentally leaves little leftovers from when something ran. This could at times save 12GB of storage space, this is suggested especially after you run the updater.")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            // MARK: Contribute Your Experiences
                            
                            VIButton(id: "CONTRIBUTE", h: $hovered) {
                                Image(systemName: "desktopcomputer")
                                Text("Contribute Your Experiences")
                            } onClick: {
                                NSWorkspace.shared.open("https://github.com/BenSova/Patched-Sur-Compatibility")
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
            EnterPasswordPrompt(password: $password, show: $showPassPrompt, onSuccess: passAction)
        }
    }
}
