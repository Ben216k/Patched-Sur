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
    @State var allowsGraphicsAcceleration = false
    @State var showOpenGLAnyway = false
    @State var showBootPlistAnyway = false
    @State var hasPatchedPlist = false
    @State var patchingPlist = false
    @State var errorX: String?
    @State var isGoing = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: NSLocalizedString("PO-ST-TITLE-ALT", comment: "PO-ST-TITLE-ALT"), s: NSLocalizedString("PO-ST-SUBTITLE", comment: "PO-ST-SUBTITLE"))
                        .alignment(.leading)
                    Spacer()
                    VIButton(id: "BACK", h: $hovered) {
                        Image(systemName: "chevron.backward.circle")
                        Text(.init("BACK"))
                    } onClick: {
                        withAnimation {
                            at = 0
                        }
                    }.inPad()
                }.padding(.top, 40)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Group {
                            Text(.init("PO-ST-SECTION-1"))
                                .font(Font.title3.bold())
                            
                            // MARK: Animations
                            
                            HStack {
                                VIButton(id: "ANI-DISABLE", h: $hovered) {
                                    Image(systemName: "dot.circle.and.cursorarrow")
                                    Text(.init("PO-ST-DA-DISABLE"))
                                } onClick: {
                                    disableAnimations()
                                    presentAlert(m: NSLocalizedString("PO-ST-DA-DISABLE-DONE", comment: "PO-ST-DA-DISABLE-DONE"), i: NSLocalizedString("PO-ST-DA-DISABLE-DONE-2", comment: "PO-ST-DA-DISABLE-DONE-2"), s: .informational)
                                }.inPad()
                                VIButton(id: "ANI-ENABLE", h: $hovered) {
                                    Image(systemName: "cursorarrow.motionlines.click")
                                    Text(.init("ENABLE"))
                                } onClick: {
                                    enableAnimations()
                                    presentAlert(m: NSLocalizedString("PO-ST-DA-ENABLE-DONE", comment: "PO-ST-DA-ENABLE-DONE"), i: NSLocalizedString("PO-ST-RESTART-APPLY", comment: "PO-ST-RESTART-APPLY"), s: .informational)
                                }.inPad()
                            }
                            Text(.init("PO-ST-DA-DESCRIPTION"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            // MARK: Graphics Switching
                            
                            HStack {
                                VIButton(id: "GX-ENABLE", h: $hovered) {
                                    Image(systemName: "arrow.triangle.swap")
                                    Text(.init("PO-ST-GXS-ENABLE"))
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
                                    Text(.init("DISABLE"))
                                } onClick: {
                                    withAnimation {
                                        showPassPrompt = true
                                    }
                                    passAction = {
                                        disableGxSwitching(p: password)
                                    }
                                }.inPad()
                            }
                            Text(.init("PO-ST-GXS-DESCRIPTION"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                                .onAppear {
                                    DispatchQueue.global(qos: .background).async {
                                        withAnimation {
                                            showOpenGLAnyway = UserDefaults.standard.bool(forKey: "OverrideMetalChecks")
                                            hasPatchedPlist = (try? call("cat /Library/Preferences/SystemConfiguration/com.apple.Boot.plist | grep no_compat_check")) != nil
                                        }
                                    }
                                }
                            
                            // MARK: Allow Graphics Acceleration Patching
                            
                            if AppInfo.openGL || showOpenGLAnyway {
                                VIButton(id: "GA-ENABLE", h: $hovered) {
                                    Image(systemName: "bolt.car")
                                    Text(.init(allowsGraphicsAcceleration ? "PO-ST-ACCEL-DISALLOW" : "PO-ST-ACCEL"))
                                } onClick: {
                                    print("Toggling allowing graphics acceleration patching...")
                                    UserDefaults.standard.setValue(!allowsGraphicsAcceleration, forKey: "AllowsAcceleration")
                                    allowsGraphicsAcceleration = !allowsGraphicsAcceleration
                                }.inPad()
                                Text(.init("PO-ST-ACCEL-DESCRIPTION"))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.bottom, 15)
                                    .onAppear {
                                        allowsGraphicsAcceleration = UserDefaults.standard.bool(forKey: "AllowsAcceleration")
                                    }
                            }
                            
                            VIButton(id: "PATCHPLIST", h: hasPatchedPlist ? .constant("NO") : $hovered) {
                                Image(systemName: "rectangle.dashed.and.paperclip")
                                Text(.init(!hasPatchedPlist ? "PO-ST-BOOT" : "PO-ST-BOOT-DONE"))
                            } onClick: {
                                if !hasPatchedPlist {
                                    print("Starting install of patched boot plist...")
                                    withAnimation {
                                        showPassPrompt = true
                                    }
                                    passAction = {
                                        patchingPlist = true
                                    }
                                }
                            }.inPad()
                            .btColor(hasPatchedPlist ? .gray : .init("Accent"))
                            Text(.init("PO-ST-BOOT-DESCRIPTION"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                                .sheet(isPresented: $patchingPlist, content: {
                                    ZStack {
                                        HStack {
                                            Spacer()
                                            VStack {
                                                if !isGoing || errorX != nil {
                                                    VIButton(id: "LCLOSE", h: $hovered) {
                                                        Image(systemName: "xmark.circle")
                                                    } onClick: { patchingPlist = false; errorX = nil }
                                                    .padding()
                                                }
                                                Spacer()
                                            }
                                        }
                                        VStack {
                                            Text(.init("PO-ST-BOOT-ONGOING"))
                                                .font(Font.system(size: 15).bold())
                                            Text(.init("PO-ST-BOOT-DESCRIPTION"))
                                                .multilineTextAlignment(.center)
                                                .padding()
                                            if let errorX = errorX {
                                                VIError(errorX)
                                            } else {
                                                VIButton(id: "NO", h: .constant("U")) {
                                                    HStack {
                                                        Image("ToolsCircle")
                                                        Text(.init("PO-ST-BOOT-ONGOING"))
                                                    }.onAppear {
                                                        if !isGoing {
                                                            isGoing = true
                                                            DispatchQueue.global(qos: .background).async {
                                                                var patchLocation = nil as String?
                                                                var cantBeUsed = false
                                                                detectPatches(installerName: { patchLocation = $0 }, legacy: { cantBeUsed = $0 }, oldKext: { cantBeUsed = $0 })
                                                                guard let patchLocation = patchLocation, !cantBeUsed else {
                                                                    errorX = NSLocalizedString("PO-ST-BOOT-NONE", comment: "PO-ST-BOOT-NONE")
                                                                    return
                                                                }
                                                                print("Using \(patchLocation) as the location, starting Patch System with --bootPlist and --noRebuild.")
                                                                patchSystem(password: password, arguments: " --bootPlist --noRebuild", location: patchLocation, unpatch: false, errorX: {
                                                                    if $0 == nil {
                                                                        isGoing = false
                                                                        hasPatchedPlist = true
                                                                        patchingPlist = false
                                                                    } else {
                                                                        errorX = $0
                                                                        isGoing = false
                                                                    }
                                                                })
                                                            }
                                                        }
                                                    }
                                                }.inPad()
                                                .btColor(.gray)
                                            }
                                        }.font(.body).frame(width: 580, height: 325)
                                    }
                                })
                        }
                        
                        Group {
                            Text(.init("PO-ST-SECTION-2"))
                                .font(Font.title3.bold())
                            
                            // MARK: Patch Kexts Logs
                            
                            VIButton(id: "PATCH-LOGS", h: $hovered) {
                                Image(systemName: "doc.text.below.ecg")
                                Text(.init("PO-ST-PKL-BUTTON"))
                            } onClick: {
                                showKextLogs = true
                            }.inPad()
                            .sheet(isPresented: $showKextLogs, content: {
                                VStack {
                                    HStack(spacing: 15) {
                                        VIHeader(p: NSLocalizedString("PO-ST-PKL-TITLE", comment: "PO-ST-PKL-TITLE"), s: "", c: .constant(true))
                                        Spacer()
                                        if UserDefaults.standard.string(forKey: "PatchKextsLastRun") != nil {
                                            VIButton(id: "LCOPY", h: $hovered) {
                                                Image(systemName: "doc.on.clipboard")
                                            } onClick: {
                                                let pasteboard = NSPasteboard.general
                                                pasteboard.declareTypes([.string], owner: nil)
                                                pasteboard.setString(UserDefaults.standard.string(forKey: "PatchKextsLastRun") ?? "No Logs Captured", forType: .string)
                                                presentAlert(m: NSLocalizedString("PO-ST-PKL-COPIED", comment: "PO-ST-PKL-COPIED"), i: NSLocalizedString("PO-ST-PKL-COPIED-2", comment: "PO-ST-PKL-COPIED-2"), s: .informational)
                                            }
                                        }
                                        VIButton(id: "LCLOSE", h: $hovered) {
                                            Image(systemName: "xmark.circle")
                                        } onClick: { showKextLogs = false }
                                    }.padding(.bottom)
                                    ScrollView {
                                        Text(UserDefaults.standard.string(forKey: "PatchKextsLastRun") ?? NSLocalizedString("PO-ST-PKL-NO-LOGS", comment: "PO-ST-PKL-NO-LOGS"))
                                            .font(.system(size: 11, design: .monospaced))
                                    }
                                }.padding(.horizontal, 30)
                                .padding(.vertical, 20)
                                .frame(width: 580, height: 305)
                            })
                            Text(.init("PO-ST-PKL-DESCRIPTION"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            // MARK: Clean Up Leftovers
                            
                            VIButton(id: "CLEAN-UP", h: $hovered) {
                                Image(systemName: "trash")
                                Text(.init("PO-ST-CL-TITLE"))
                            } onClick: {
                                cleanLeftovers()
                            }.inPad()
                            Text(.init("PO-ST-CL-DESCRIPTION"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            // MARK: Contribute Your Experiences
                            
                            VIButton(id: "CONTRIBUTE", h: $hovered) {
                                Image(systemName: "desktopcomputer")
                                Text(.init("PO-ST-CYE-TITLE"))
                            } onClick: {
                                NSWorkspace.shared.open("https://github.com/BenSova/Patched-Sur-Compatibility")
                            }.inPad()
                            Text(.init("PO-ST-CYE-DESCRIPTION"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            VIButton(id: "RELAUNCH", h: $hovered) {
                                Image(systemName: "arrow.up.forward.app")
                                Text(.init("PO-ST-RL-TITLE"))
                            } onClick: {
                                relaunchPatcher()
                            }.inPad()
                            Text(.init("PO-ST-RL-DESCRIPTION"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 20)
                        }
                        
                        Group {
                            
                            // MARK: Thanks!
                            
                            Text(.init("THANKS-TITLE"))
                                .font(Font.title3.bold())
                                .padding(.bottom, -2)
                            
                            Text(.init("THANKS-CONTENT"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            // MARK: Friends :D
                            
                            Text(.init("PO-ST-FRIENDS"))
                                .font(Font.title3.bold())
                            
                            VIButton(id: "FRIENDS-WIDGY", h: $hovered) {
                                Image("WidgyMark")
                                    .font(.body)
                                Text("Widgy")
                            } onClick: {
                                NSWorkspace.shared.open("https://apps.apple.com/us/app/widgy/id1524540481")
                            }.inPad()
                            Text(.init("PO-ST-FRIENDS-WIDGY"))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            VIButton(id: "FRIENDS-ICONS", h: $hovered) {
                                Image(systemName: "app")
                                    .font(.system(size: 15).weight(.medium))
                                Text("macOSicons.com")
                            } onClick: {
                                NSWorkspace.shared.open("https://macosicons.com")
                            }.inPad()
                            Text(.init("PO-ST-FRIENDS-WIDGY"))
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

//enum {
//    case YES = true
//}
