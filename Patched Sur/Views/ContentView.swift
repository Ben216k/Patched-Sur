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
    let releaseTrack: String
    var model: String
    var buildNumber: String
    var body: some View {
        ZStack {
            switch atLocation {
            case 0:
//                MainView(at: $atLocation, buildNumber: buildNumber, model: model)
                MainView(at: $atLocation, model: model)
            case 1:
                Color.white.opacity(0.001)
                UpdateView(at: $atLocation, buildNumber: buildNumber)
            case 2:
                Color.white.opacity(0.001)
                PatchKextsView(at: $atLocation)
            case 3:
                Color.white.opacity(0.001)
                AboutMyMac(releaseTrack: releaseTrack, model: model, buildNumber: buildNumber, at: $atLocation)
            case 4:
                Color.white.opacity(0.001)
                PSSettings(at: $atLocation)
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
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("v\(AppInfo.version) (\(AppInfo.build))")
                        .font(.caption)
                        .padding()
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
    var model: String
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                VIHeader(p: "Patched Sur", s: "v\(AppInfo.version) (\(AppInfo.build))")
                    .alignment(.leading)
                    .padding(.leading, 30)
                Spacer()
                VIButton(id: "GITHUB", h: $hovered) {
                    Image("GitHubMark")
                } onClick: {
                    NSWorkspace.shared.open("https://github.com/BenSova/Patched-Sur")
                }
                VIButton(id: "INFO", h: $hovered) {
                    Image(systemName: "info.circle")
                } onClick: {
                    at = 3
                }
                .padding(.trailing, 30)
            }.padding(.top, 40)
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                VISimpleCell(t: "Update macOS", d: "Go from your current version of macOS to a newer one,\nwhere there's something new.", s: "arrow.clockwise.circle", id: "UPDATE", h: $hovered) {
                    at = 1
                }
                VISimpleCell(t: "Patch Kexts", d: "Kexts provide macOS with it's full functionality. So that\neverything works like it should.", s: "doc.circle", id: "KEXTS", h: $hovered) {
                    if !model.hasPrefix("iMac14,") {
                        at = 2
                    } else {
                        let errorAlert = NSAlert()
                        errorAlert.alertStyle = .informational
                        errorAlert.informativeText = "You don't need to patch the kexts on Late 2013 iMacs. Big Sur is already running at full functionality."
                        errorAlert.messageText = "Patch Kexts Unnecessary"
                        errorAlert.runModal()
                    }
                }
                VISimpleCell(t: "Settings", d: "Disable animations, enable graphics switching, show\nlogs from Patch Kexts, and maybe more.", s: "gearshape", id: "ABOUT", h: $hovered) {
                    at = 4
                }
            }.padding(.horizontal, 40)
            .padding(.bottom)
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
