//
//  ContentView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import VeliaUI
import SwiftUI
import UserNotifications

// MARK: - Content View

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var atLocation: Int
    @State var password = ""
    let releaseTrack: String
    var model: String
    var buildNumber: String
    var body: some View {
        ZStack {
            switch atLocation {
            case 0:
//                MainView(at: $atLocation, buildNumber: buildNumber, model: model)
                MainView(at: $atLocation, model: model).transition(.moveAway)
            case 1:
                Color.white.opacity(0.001)
                UpdateView(at: $atLocation, buildNumber: buildNumber).transition(.moveAway)
            case 2:
                Color.white.opacity(0.001)
                PatchKextsView(at: $atLocation, password: $password).transition(.moveAway)
            case 3:
                Color.white.opacity(0.001)
                AboutMyMac(releaseTrack: releaseTrack, model: model, buildNumber: buildNumber, at: $atLocation).transition(.moveAway)
            case 4:
                Color.white.opacity(0.001)
                PSSettings(at: $atLocation, password: $password).transition(.moveAway)
            case 5:
                Color.white.opacity(0.001)
                CreateInstallerOverView(at: $atLocation).transition(.moveAway)
            case 6:
                Color.white.opacity(0.001)
                RecoveryPatchView(at: $atLocation).transition(.moveAway)
            case 7:
                Color.white.opacity(0.001)
                NVRAMResetHelp(at: $atLocation).transition(.moveAway)
            default:
                Color.white.opacity(0.001)
                VStack {
                    Text("Invalid Progress Number\natLocal: \(atLocation)")
                    Button {
                        atLocation = 0
                    } label: {
                        Text("Back")
                    }
                }.frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
            }
            if atLocation != 0 && atLocation != 5 && atLocation != 1 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("v\(AppInfo.version) (\(AppInfo.build))")
                            .font(.caption)
                            .padding()
                    }
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    init(at: Binding<Int>) {
        _ = try? call("[[ -d ~/.patched-sur ]] || mkdir ~/.patched-sur")
        model = (try? call("nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product")) ?? "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product \((try? call("sysctl -n hw.model")) ?? "MacModelX,Y")"
        model.removeFirst("4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product ".count)
        print("Detected Mac Model: \(model)")
        buildNumber = (try? call("sw_vers | grep BuildVersion:")) ?? "20xyyzzz"
        if buildNumber.count > 14 {
            buildNumber.removeFirst(14)
        } else {
            AppInfo.preventUpdate = true
        }
        print("Detected macOS Build Number: \(buildNumber)")
        var track = UserDefaults.standard.string(forKey: "UpdateTrack")
        if track == nil { track = "Release" }
        releaseTrack = track!
        print("Detected Release Track: \(releaseTrack)")
        print("Loading Main Screen...")
        print("")
        self._atLocation = at
    }
}

// MARK: - Main View

struct MainView: View {
    @State var hovered: String?
    @Binding var at: Int
    @State var hasNVRAMProblem = false
    @State var wantsKextUpdate = false
    var model: String
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                VIHeader(p: "Patched Sur", s: "v\(AppInfo.version) (\(AppInfo.build)) \(AppInfo.nothing ? "I'm Lazy" : "")")
                    .alignment(.leading)
                    .padding(.leading, 30)
                Spacer()
                VIButton(id: "GITHUB", h: $hovered) {
                    Image("GitHubMark")
                } onClick: {
                    NSWorkspace.shared.open("https://github.com/BenSova/Patched-Sur")
                }
                .padding(.trailing, 30)
            }.padding(.top, 40).frame(width: 600, alignment: .center)
            Spacer()
            VStack {
                HStack {
                    VStack {
                        VStack(alignment: .leading, spacing: 7) {
                            VISimpleCell(t: NSLocalizedString("PO-UP-TITLE", comment: "PO-UP-TITLE"), d: NSLocalizedString("PO-UP-DESCRIPTION", comment: "PO-UP-DESCRIPTION"), s: "arrow.clockwise.circle", id: "UPDATE", h: $hovered) {
                                if !hasNVRAMProblem {
                                    withAnimation {
                                        at = 1
                                    }
                                } else {
                                    presentAlert(m: NSLocalizedString("PO-NV-NOUP-TITLE", comment: "PO-NV-NOUP-TITLE"), i: NSLocalizedString("PO-NV-NOUP-CONTENT", comment: "PO-NV-NOUP-CONTENT"))
                                }
                            }
                            VISimpleCell(t: NSLocalizedString("PO-PK-TITLE", comment: "PO-PK-TITLE"), d: NSLocalizedString("PO-PK-DESCRIPTION", comment: "PO-PK-DESCRIPTION"), s: "doc.circle", id: "KEXTS", h: $hovered) {
                                if !model.hasPrefix("iMac14,") {
                                    withAnimation {
                                        at = 2
                                    }
                                } else {
                                    let errorAlert = NSAlert()
                                    errorAlert.alertStyle = .informational
                                    errorAlert.informativeText = NSLocalizedString("PO-PK-NO-NEED-DESCRIPTION", comment: "PO-PK-NO-NEED-DESCRIPTION")
                                    errorAlert.messageText = NSLocalizedString("PO-PK-NO-NEED-TITLE", comment: "PO-PK-NO-NEED-TITLE")
                                    errorAlert.runModal()
                                }
                            }
                            VISimpleCell(t: NSLocalizedString("PO-ST-TITLE", comment: "PO-ST-TITLE"), d: NSLocalizedString("PO-ST-DESCRIPTION", comment: "PO-ST-DESCRIPTION"), s: "gearshape", id: "SETINGS", h: $hovered) {
                                withAnimation {
                                    at = 4
                                }
                            }
                        }
                    }
                    VStack {
                        VStack(alignment: .leading, spacing: 7) {
                            VISimpleCell(t: NSLocalizedString("PO-CI-TITLE", comment: "PO-CI-TITLE"), d: NSLocalizedString("PO-CI-DESCRIPTION", comment: "PO-CI-DESCRIPTION"), s: "externaldrive", id: "CREATEINSTALLER", h: $hovered) {
                                withAnimation {
                                    at = 5
                                }
                            }
                            VISimpleCell(t: NSLocalizedString("PO-IR-TITLE", comment: "PO-IR-TITLE"), d: NSLocalizedString("PO-IR-DESCRIPTION", comment: "PO-IR-DESCRIPTION"), s: "asterisk.circle", id: "RECOVERY", h: $hovered) {
                                withAnimation {
                                    at = 6
                                }
                            }
                            VISimpleCell(t: NSLocalizedString("PO-AMM-TITLE", comment: "PO-AMM-TITLE"), d:NSLocalizedString("PO-AMM-DESCRIPTION", comment: "PO-AMM-DESCRIPTION"), s: "info.circle", id: "ABOUT", h: $hovered) {
                                withAnimation {
                                    at = 3
                                }
                            }
                        }
                    }
                }.padding(.horizontal, 40)
                if hasNVRAMProblem {
                    VIButton(id: "NVRAMPROBLEM", h: $hovered) {
                        Text("Patched Sur detected a problem! Click here to resolve it.")
                            .font(.caption)
                    } onClick: {
                        withAnimation {
                            at = 7
                        }
                    }.btColor(.red)
                        .inPad()
                }
            }.padding(.bottom)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        withAnimation {
                            guard let bootArgs = try? call("nvram boot-args") else {
                                hasNVRAMProblem = true
                                return
                            }
                            if !bootArgs.contains("-no_compat_check") {
                                hasNVRAMProblem = true
                                return
                            }
                        }
                    }
                }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension AnyTransition {
    static var moveAway: AnyTransition {
        return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    }
    static var moveAway2: AnyTransition {
        return AnyTransition.asymmetric(insertion: AnyTransition.modifier(active: InsertItem(a: false), identity: InsertItem(a: true)), removal: AnyTransition.modifier(active: DeleteItem(a: false), identity: DeleteItem(a: true)))
    }
}

struct InsertItem: ViewModifier {
    let a: Bool
    func body(content: Content) -> some View {
        content
            .offset(x: a ? 0 : 200, y: 0)
            .opacity(a ? 1 : 0)
    }
}

struct DeleteItem: ViewModifier {
    let a: Bool
    func body(content: Content) -> some View {
        content
            .offset(x: a ? 0 : -100, y: 0)
            .opacity(a ? 1 : 0)
    }
}
