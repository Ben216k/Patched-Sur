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
    @State var unpatch = false
    @State var errorX = ""
    @State var showAdvanced = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 15) {
                    VIHeader(p: unpatch ? NSLocalizedString("PO-PK-TITLE-ALT", comment: "PO-PK-TITLE-ALT") : NSLocalizedString("PO-PK-TITLE", comment: "PO-PK-TITLE"), s: NSLocalizedString("PO-PK-SUBTITLE", comment: "PO-PK-SUBTITLE"), c: $topCompress)
                        .alignment(.leading)
                    Spacer()
                    VIButton(id: "BACK", h: $hovered) {
                        Image(systemName: "chevron.backward.circle")
                            .font(topCompress ? Font.system(size: 11).weight(.bold) : Font.body.weight(.medium))
                        Text(.init("BACK"))
                            .font(topCompress ? Font.system(size: 11).weight(.medium) : Font.body)
                            .padding(.leading, -5)
                    } onClick: {
                        withAnimation {
                            at = 0
                        }
                    }.inPad()
                }.padding(.top, 40)
                Spacer()
                if !showAdvanced {
                    VStack {
                        Text(unpatch ? NSLocalizedString("PO-PK-TITLE-ALT", comment: "PO-PK-TITLE-ALT") : NSLocalizedString("PO-PK-TITLE", comment: "PO-PK-TITLE"))
                            .font(.system(size: 15)).bold()
                        Text(.init("PO-PK-DESCRIPTION-2"))
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 9)
                            .padding(.top, progress == -2 ? -4 : 0)
                        switch progress {
                        case 0:
                            VIButton(id: "STARTKP", h: $hovered) {
                                Text(.init(unpatch ? "PO-PK-UN-START" : "PO-PK-START"))
                                Image(systemName: "chevron.forward.circle")
                                    .font(Font.system(size: 15).weight(.medium))
                            } onClick: {
                                withAnimation {
                                    progress = 1
                                    topCompress = true
                                }
                            }.inPad()
                            .transition(.moveAway2)
                            VIButton(id: "CHOOSEDIFF", h: $hovered) {
                                Text(.init("PO-PK-CONFIGURE"))
                                    .font(.caption)
                            } onClick: {
                                withAnimation {
                                    showAdvanced.toggle()
                                    topCompress = true
                                }
                            }.inPad()
                            .btColor(.gray)
                            .transition(.moveAway2)
                        case 1:
                            VIButton(id: "NEVER", h: .constant("NO")) {
                                Image("ToolsCircle")
                                Text(.init("PO-PK-DETECT"))
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
                                    Text(.init("PO-PK-NONE-DETECTED"))
                                }.inPad()
                                .btColor(.red)
                                VIButton(id: "REFRESH", h: $hovered) {
                                    Image(systemName: "arrow.triangle.2.circlepath.circle")
                                        .font(Font.system(size: 15).weight(.medium))
                                    Text(.init("REFRESH"))
                                } onClick: {
                                    withAnimation {
                                        progress = 1
                                    }
                                }.inPad()
                            }.transition(.moveAway2)
                            Text(.init("PO-PK-NONE-HELP"))
                                .font(.caption)
                                .transition(.moveAway2)
                        case 2:
                            VIButton(id: "REQUESTROOT", h: $hovered) {
                                Text(.init("REQUEST-ROOT"))
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
                                Text(.init(unpatch ? "PO-PK-UN-RUNNING" : "PO-PK-RUNNING"))
                            }.inPad()
                            .btColor(.gray)
                            .onAppear {
                                DispatchQueue.global(qos: .background).async {
                                    patchKexts(password: password, legacy: legacy, unpatch: unpatch, location: installerName) { errorY in
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
                                Text(.init("RESTART-TO-FINISH"))
                            } onClick: {
                                if !AppInfo.nothing {
                                    _ = try? call("reboot", p: password)
                                }
                            }.inPad()
                        case -2:
                            VIError(errorX)
                        default:
                            Text("How did you do this?")
                                .transition(.moveAway2)
                        }
                    }.transition(.moveAway)
                } else {
                    ConfigurePatchKexts(showAdvanced: $showAdvanced)
                        .transition(.moveAway)
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
                            Text(.init("PO-PK-LEGACY-ALERT"))
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

struct ConfigurePatchKexts: View {
    @State var hovered: String?
    @State var isPatching = true
    @State var wifi = PSWiFiKext.mojaveHybrid
    @State var legacyUSB = false
    @State var hd3000 = false
    @State var hda = false
    @State var bcm5701 = false
    @State var gfTesla = false
    @State var nvNet = false
    @State var telemetry = false
    @State var acceleration = false
    @Binding var showAdvanced: Bool
    
    var body: some View {
        VStack {
            Text("WARNING: Advanced configurations should only be used if you know what you are doing!\nMake sure not to enable patches you don't need.")
                .font(.caption)
                .multilineTextAlignment(.center)
            HStack {
                Text("Mode:")
                VIButton(id: "PATCH-UNPATCH", h: $hovered) {
                    Text(.init(isPatching ? "PO-PK-TITLE" : "PO-PK-TITLE-ALT"))
                } onClick: {
                    withAnimation {
                        isPatching.toggle()
                    }
                }.btColor(isPatching ? .accentColor : .red)
                .inPad()
            }
            if isPatching {
                ScrollView(showsIndicators: false) {
                    HStack(spacing: 15) {
                        VStack {
                            HStack {
                                Text("WiFi:")
                                VIButton(id: "WiFi", h: $hovered) {
                                    Text(wifi.rawValue)
                                } onClick: {
                                    withAnimation {
                                        wifi.toggle()
                                    }
                                }.inPad()
                                .btColor(wifi == .none ? .gray : (wifi == .mojaveHybrid ? Color("Accent") : .red))
                            }
                            HStack {
                                Text("Legacy USB:")
                                VIButton(id: "USB", h: $hovered) {
                                    Text(legacyUSB ? "Enabled" : "Disabled")
                                } onClick: {
                                    withAnimation {
                                        legacyUSB.toggle()
                                    }
                                }.inPad()
                                .btColor(!legacyUSB ? .gray : .red)
                            }
                            HStack {
                                Text("BCM5701:")
                                VIButton(id: "BCM5701", h: $hovered) {
                                    Text(bcm5701 ? "Enabled" : "Disabled")
                                } onClick: {
                                    withAnimation {
                                        bcm5701.toggle()
                                    }
                                }.inPad()
                                .btColor(!bcm5701 ? .gray : .red)
                            }
                            HStack {
                                Text("NVENET:")
                                VIButton(id: "NVENET", h: $hovered) {
                                    Text(nvNet ? "Enabled" : "Disabled")
                                } onClick: {
                                    withAnimation {
                                        nvNet.toggle()
                                    }
                                }.inPad()
                                .btColor(!nvNet ? .gray : .red)
                            }
                        }
                        VStack {
                            HStack {
                                Text("HD3000:")
                                VIButton(id: "HD3000", h: $hovered) {
                                    Text(hd3000 ? "Enabled" : "Disabled")
                                } onClick: {
                                    withAnimation {
                                        hd3000.toggle()
                                    }
                                }.inPad()
                                .btColor(!hd3000 ? .gray : .red)
                            }
                            HStack {
                                Text("HDA:")
                                VIButton(id: "HDA", h: $hovered) {
                                    Text(hda ? "Enabled" : "Disabled")
                                } onClick: {
                                    withAnimation {
                                        hda.toggle()
                                    }
                                }.inPad()
                                .btColor(!hda ? .gray : .red)
                            }
                            HStack {
                                Text("GFTESLA:")
                                VIButton(id: "GFTESLA", h: $hovered) {
                                    Text(gfTesla ? "Enabled" : "Disabled")
                                } onClick: {
                                    withAnimation {
                                        gfTesla.toggle()
                                    }
                                }.inPad()
                                .btColor(!gfTesla ? .gray : .red)
                            }
                            HStack {
                                Text("TELEMETRY:")
                                VIButton(id: "TELEMETRY", h: $hovered) {
                                    Text(telemetry ? "Deactivated" : "Leave Alone")
                                } onClick: {
                                    withAnimation {
                                        telemetry.toggle()
                                    }
                                }.inPad()
                                .btColor(!telemetry ? .gray : .red)
                            }
                        }
                    }
                    if UserDefaults.standard.bool(forKey: "AllowsAcceleration") {
                        HStack {
                            Text("OpenGL Acceleration:")
                            VIButton(id: "ACCELERATION", h: $hovered) {
                                Text(acceleration ? "Enabled" : "Disabled")
                            } onClick: {
                                withAnimation {
                                    acceleration.toggle()
                                }
                            }.inPad()
                            .btColor(!acceleration ? .gray : .red)
                        }
                    }
                }
            } else {
                Text("All kext patches will be uninstalled and the system will be restored to it's old unpatched state. WiFi won't work and possibly other things, this cannot be configured. This could break the system kernel collection resulting in either a kernel panicking Mac or the inability to repatch the kexts, so it's generally safer to just reinstall macOS instead of unpatching.")
                    .multilineTextAlignment(.center)
            }
            HStack {
                VIButton(id: "BACK", h: $hovered) {
                    Image("BackArrowCircle")
                    Text(.init("BACK"))
                } onClick: {
                    withAnimation {
                        showAdvanced = false
                    }
                }.inPad()
                .btColor(.gray)
                VIButton(id: "STARTKP", h: $hovered) {
                    Text(.init(isPatching ? "PO-PK-START" : "PO-PK-UN-START"))
                    Image(systemName: "chevron.forward.circle")
                        .font(Font.system(size: 15).weight(.medium))
                }.inPad()
                .btColor(isPatching ? .accentColor : .red)
            }
        }.font(.system(size: 12))
    }
}
