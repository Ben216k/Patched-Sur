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
    @State var oldKext = false
    @State var patchSystemArguments: String?
    
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
                        
                        // MARK: Start Patch Kext Button
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
                                    progress = 10
                                }
                            }.inPad()
                            .btColor(.gray)
                            .transition(.moveAway2)
                            
                        // MARK: Detecting Patches
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
                                }, legacy: { legacy = $0 }, oldKext: { oldKext = $0; legacy = $0 })
                            }
                            
                        // MARK: No Patches Detected
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
                        
                        // MARK: Request Root
                        case 2, 10:
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
                            
                        // MARK: Patching Kexts
                        case 3:
                            VIButton(id: "No", h: .constant("")) {
                                Image("FileCircle")
                                Text(.init(unpatch ? "PO-PK-UN-RUNNING" : "PO-PK-RUNNING"))
                            }.inPad()
                            .btColor(.gray)
                            .onAppear {
                                DispatchQueue.global(qos: .background).async {
                                    if patchSystemArguments != nil || !oldKext {
                                        patchSystem(password: password, arguments: patchSystemArguments ?? " --detect", location: installerName, unpatch: unpatch) { errorY in
                                            if let errorY = errorY {
                                                errorX = errorY
                                                progress = -2
                                            } else {
                                                progress = 4
                                            }
                                        }
                                    } else {
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
                            }
                            
                        // MARK: Restart to Finish
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
                    // MARK: Configure Patch Kexts Link
                    ConfigurePatchKexts(unpatch: $unpatch, showAdvanced: $showAdvanced, startPatch: {
                        patchSystemArguments = $0
                        installerName = $1
                        withAnimation {
                            showAdvanced = false
                            progress = 3
                        }
                    }, password: password)
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
                    if progress == 2 {
                        progress = 3
                    } else {
                        progress = 0
                        showAdvanced.toggle()
                        topCompress = true
                    }
                }
            }
        }
    }
}

// MARK: Configure Patch Kexts

struct ConfigurePatchKexts: View {
    @State var hovered: String?
    @Binding var unpatch: Bool
    @State var wifi = PSWiFiKext.none
    @State var bootPlist = false
    @State var legacyUSB = false
    @State var hd3000 = false
    @State var hda = false
    @State var bcm5701 = false
    @State var gfTesla = false
    @State var nvNet = false
    @State var mccs = false
    @State var agc = false
    @State var agcold = false
    @State var vit9696 = false
    @State var backlight = false
    @State var fixup = false
    @State var telemetry = false
    @State var snb = PSSNBKext.none
    @State var acceleration = false
    @State var detectedPatches = false
    @State var lookVolume = ""
    @Binding var showAdvanced: Bool
    let startPatch: (String, String) -> ()
    let password: String
    
    var body: some View {
        VStack {
            Text(.init("PO-PK-CONFIG-WARN"))
                .font(.caption)
                .multilineTextAlignment(.center)
            if detectedPatches {
                HStack {
                    Text(.init("PO-PK-CONFIG-MODE"))
                    VIButton(id: "PATCH-UNPATCH", h: $hovered) {
                        Text(.init(!unpatch ? "PO-PK-TITLE" : "PO-PK-TITLE-ALT"))
                    } onClick: {
                        withAnimation {
                            unpatch.toggle()
                        }
                    }.btColor(!unpatch ? .accentColor : .red)
                    .inPad()
                }
                if !unpatch {
                    ScrollView(showsIndicators: false) {
                        HStack(spacing: 15) {
                            VStack {
                                // MARK: Column One
                                HStack {
                                    Text("WiFi:")
                                    VIButton(id: "WiFi", h: $hovered) {
                                        Text(wifi.rawValue)
                                    } onClick: {
                                        withAnimation {
                                            wifi.toggle()
                                        }
                                    }.inPad()
                                    .btColor(wifi == .none ? .gray : (wifi == .mojaveHybrid ? Color("Accent") : .accentColor))
                                }
                                HStack {
                                    Text("Legacy USB:")
                                    VIButton(id: "USB", h: $hovered) {
                                        Text(legacyUSB ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            legacyUSB.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!legacyUSB ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("BCM5701:")
                                    VIButton(id: "BCM5701", h: $hovered) {
                                        Text(bcm5701 ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            bcm5701.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!bcm5701 ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("NVENET:")
                                    VIButton(id: "NVENET", h: $hovered) {
                                        Text(nvNet ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            nvNet.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!nvNet ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("AGC:")
                                    VIButton(id: "AGC", h: $hovered) {
                                        Text(agc ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            agc.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!agc ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("AGC Old:")
                                    VIButton(id: "AGC-OLD", h: $hovered) {
                                        Text(agcold ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            agcold.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!agcold ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("SNB:")
                                    VIButton(id: "SNB", h: $hovered) {
                                        Text(snb.rawValue)
                                    } onClick: {
                                        withAnimation {
                                            snb.toggle()
                                        }
                                    }.inPad()
                                    .btColor(snb == .none ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("Backlight:")
                                    VIButton(id: "BACKLIGHT", h: $hovered) {
                                        Text(backlight ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            backlight.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!backlight ? .gray : .accentColor)
                                }
                            }
                            VStack {
                                // MARK: Column Two
                                HStack {
                                    Text("Boot Plist:")
                                    VIButton(id: "BOOT-PLIST", h: $hovered) {
                                        Text(bootPlist ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            bootPlist.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!bootPlist ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("HD3000:")
                                    VIButton(id: "HD3000", h: $hovered) {
                                        Text(hd3000 ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            hd3000.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!hd3000 ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("HDA:")
                                    VIButton(id: "HDA", h: $hovered) {
                                        Text(hda ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            hda.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!hda ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("GFTESLA:")
                                    VIButton(id: "GFTESLA", h: $hovered) {
                                        Text(gfTesla ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            gfTesla.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!gfTesla ? .gray : .accentColor)
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
                                    .btColor(!telemetry ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("MCCS:")
                                    VIButton(id: "MCCS", h: $hovered) {
                                        Text(mccs ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            mccs.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!mccs ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("VIT9696:")
                                    VIButton(id: "vit9696", h: $hovered) {
                                        Text(vit9696 ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            vit9696.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!vit9696 ? .gray : .accentColor)
                                }
                                HStack {
                                    Text("Fix Up:")
                                    VIButton(id: "FIXUP", h: $hovered) {
                                        Text(fixup ? .init("ENABLED") : .init("DISABLED"))
                                    } onClick: {
                                        withAnimation {
                                            fixup.toggle()
                                        }
                                    }.inPad()
                                    .btColor(!fixup ? .gray : .accentColor)
                                }
                            }
                        }
                        if UserDefaults.standard.bool(forKey: "AllowsAcceleration") {
                            // MARK: OpenGL Acceleration
                            HStack {
                                Text("OpenGL Acceleration:")
                                VIButton(id: "ACCELERATION", h: $hovered) {
                                    Text(acceleration ? .init("ENABLED") : .init("DISABLED"))
                                } onClick: {
                                    withAnimation {
                                        acceleration.toggle()
                                    }
                                }.inPad()
                                .btColor(!acceleration ? .gray : .accentColor)
                            }
                        }
                    }
                } else {
                    Text(.init("PO-PK-CONFIG-UNPATCH"))
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
                    
                    // MARK: Start Patch Systewm
                    VIButton(id: "STARTKP", h: $hovered) {
                        Text(.init(!unpatch ? "PO-PK-START" : "PO-PK-UN-START"))
                        Image(systemName: "chevron.forward.circle")
                            .font(Font.system(size: 15).weight(.medium))
                    } onClick: {
                        let args = argumentsFromValues(wifi: wifi, bootPlist: bootPlist, legacyUSB: legacyUSB, hd3000: hd3000, hda: hda, bcm5701: bcm5701, gfTesla: gfTesla, nvNet: nvNet, mccs: mccs, agc: agc, vit9696: vit9696, backlight: backlight, fixup: fixup, telemetry: telemetry, snb: snb, acceleration: acceleration)
                        startPatch(args, lookVolume)
                    }.inPad()
                    .btColor(!unpatch ? .accentColor : .red)
                }
            } else {
                Spacer()
                VIButton(id: "NOU", h: .constant("NO")) {
                    Image("RefreshCircle")
                    Text(.init("PO-PK-DETECT"))
                }.inPad()
                .btColor(.gray)
                .onAppear {
                    detectPatches { volume in
                        if let volume = volume {
                            lookVolume = volume
                        } else {
                            fatalError("Can't open advanced patches without any patches available.")
                        }
                    } legacy: { isLegacy in
                        if isLegacy {
                            fatalError("Can't open advanced patches without a new version of the patcher.")
                        }
                    } oldKext: { if $0 { fatalError("Can't open advanced patches without a new version of the patcher.") } }
                    do {
                        let needed = try call("\(lookVolume)/NeededPatches.sh", p: password)
                        if needed.contains("WIFI") {
                            wifi = .mojaveHybrid
                        }; if needed.contains("HD3000") {
                            hd3000 = true
                        }; if needed.contains("HDA") {
                            hda = true
                        }; if needed.contains("BCM5701") {
                            bcm5701 = true
                        }; if needed.contains("GFTESLA") {
                            gfTesla = true
                        }; if needed.contains("NVNET") {
                            nvNet = true
                        }; if needed.contains("MCCS") {
                            mccs = true
                        }; if needed.contains("AGC") {
                            agc = true
                        }; if needed.contains("AGCOLD") {
                            agcold = true
                        }; if needed.contains("VIT9696") {
                            vit9696 = true
                        }; if needed.contains("BACKLIGHT") {
                            backlight = true
                        }; if needed.contains("FIXUP") {
                            fixup = true
                        }; if needed.contains("TELEMETRY") {
                            telemetry = true
                        }; if needed.contains("SMBBUNDLE") {
                            snb = .bundle
                        }; if needed.contains("SMBKEXT") {
                            snb = .kext
                        }; if needed.contains("BOOTPLIST") {
                            bootPlist = true
                        }
                        detectedPatches = true
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
                Spacer()
            }
        }.font(.system(size: 12))
    }
}
