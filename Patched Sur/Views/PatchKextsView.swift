//
//  PatchKextsView.swift
//  Patched Sur
//
//  Created by Ben Sova on 3/24/21.
//

import VeliaUI

struct PatchKextsView: View {
    @State var hovered: String?
    @Binding var at: Int
    @State var progress = 0
    @State var installerName = ""
    @State var topCompress = false
    @Binding var password: String
    @State var showPassPrompt = false
    @State var legacy = false
    @State var errorX = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: "Patch Kexts", s: "Make Drivers Work Basically", c: $topCompress)
                        .alignment(.leading)
                    Spacer()
                    VIButton(id: "BACK", h: $hovered) {
                        Image(systemName: "chevron.backward.circle")
                            .font(topCompress ? Font.system(size: 11).weight(.bold) : Font.body.weight(.medium))
                        Text("Back")
                            .font(topCompress ? Font.system(size: 11).weight(.medium) : Font.body)
                            .padding(.leading, -5)
                    } onClick: {
                        withAnimation {
                            at = 0
                        }
                    }.inPad()
                }.padding(.top, 40)
                Spacer()
                Text("Patch Kexts")
                    .font(.system(size: 15)).bold()
                Text("Patching your kexts gets you Wifi, USB, and many other things working on your Big Sur installation. Without these kexts, your Mac would not be at its full potential on Big Sur, and several things would not work. If you need to, you can unpatch the kexts then repatch them which might solve a problem. Sometimes, it might be a good idea to wait a little bit before running patch kexts, since some things might be interfering with the System volume.")
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 9)
                    .padding(.top, progress == -2 ? -4 : 0)
                switch progress {
                case 0:
                    VIButton(id: "STARTKP", h: $hovered) {
                        Text("Start Patch Kexts")
                        Image(systemName: "chevron.forward.circle")
                            .font(Font.system(size: 15).weight(.medium))
                    } onClick: {
                        withAnimation {
                            progress = 1
                            topCompress = true
                        }
                    }.inPad()
                    .transition(.moveAway2)
                case 1:
                    VIButton(id: "NEVER", h: .constant("NO")) {
                        Image("ToolsCircle")
                        Text("Detecting Patches")
                    }.inPad()
                    .btColor(.gray)
                    .transition(.moveAway2)
                    .onAppear {
                        detectPatches(installerName: { (location) in
                            withAnimation {
                                if let location = location {
                                    installerName = location
                                    progress = 2
                                } else {
                                    progress = -1
                                }
                            }
                        }, legacy: { legacy = $0 })
                    }
                case -1:
                    HStack {
                        VIButton(id: "NOPATCHER", h: .constant("")) {
                            Image(systemName: "exclamationmark.circle")
                                .font(Font.system(size: 15).weight(.medium))
                            Text("Patch Resources Were Not Detected")
                        }.inPad()
                        .btColor(.red)
                        VIButton(id: "REFRESH", h: $hovered) {
                            Image(systemName: "arrow.triangle.2.circlepath.circle")
                                .font(Font.system(size: 15).weight(.medium))
                            Text("Refresh")
                        } onClick: {
                            withAnimation {
                                progress = 1
                            }
                        }.inPad()
                    }.transition(.moveAway2)
                    Text("Try Plugging in a Patched Installer USB")
                        .font(.caption)
                        .transition(.moveAway2)
                case 2:
                    VIButton(id: "REQUESTROOT", h: $hovered) {
                        Text("Request Root Permissions")
                    } onClick: {
                        withAnimation {
                            showPassPrompt = true
                        }
                    }.inPad()
                    .transition(.moveAway2)
                    .onAppear {
                        withAnimation(Animation.default.delay(0.25)) {
                            showPassPrompt = true
                        }
                    }
                case 3:
                    VIButton(id: "No", h: .constant("")) {
                        Image("FileCircle")
                        Text("Patching Kexts")
                    }.inPad()
                    .btColor(.gray)
                    .onAppear {
                        DispatchQueue.global(qos: .background).async {
                            patchKexts(password: password, legacy: legacy, location: installerName) { errorY in
                                if let errorY = errorY {
                                    errorX = errorY
                                    progress = -2
                                } else {
                                    progress = 4
                                }
                            }
                        }
                    }
                case 4:
                    VIButton(id: "Restart", h: $hovered) {
                        Image(systemName: "restart.circle")
                            .font(Font.system(size: 15).weight(.medium))
                        Text("Restart to Finish")
                    } onClick: {
                        
                    }.inPad()
                case -2:
                    VIError(errorX)
                default:
                    Text("How did you do this?")
                        .transition(.moveAway2)
                }
                Spacer()
            }.padding(.horizontal, 30)
            .padding(.bottom)
            if legacy {
                VStack {
                    Spacer()
                    ZStack {
                        Color.orange
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(Font.system(size: 13).weight(.medium))
                                .padding(.trailing, -2)
                            Text("The Only Detected Patches Require Legacy Mode")
                                .font(Font.system(size: 12))
                        }.padding(3)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                    }.fixedSize()
                    .cornerRadius(15)
                    .padding(.bottom, 10)
                }
            }
            EnterPasswordPrompt(password: $password, show: $showPassPrompt) {
                withAnimation {
                    progress = 3
                }
            }
        }
    }
}
