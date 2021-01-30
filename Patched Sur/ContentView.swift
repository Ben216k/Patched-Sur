//
//  ContentView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var atLocation: Int
    let systemVersion: String
    let releaseTrack: String
    var gpu: String
    var model: String
    var cpu: String
    var memory: String
    var buildNumber: String
    var body: some View {
        ZStack {
//            colorScheme == .dark ? Color.black : Color.white
            if atLocation == 0 {
                MainView(at: $atLocation, buildNumber: buildNumber, model: model)
            } else if atLocation == 1 {
                UpdateView(at: $atLocation, buildNumber: buildNumber)
            } else if atLocation == 2 {
                KextPatchView(at: $atLocation)
            } else if atLocation == 3 {
                AboutMyMac(systemVersion: systemVersion, releaseTrack: releaseTrack, gpu: gpu, model: model, cpu: cpu, memory: memory, buildNumber: buildNumber, at: $atLocation)
            } else if atLocation == 4 {
                Settings(releaseTrack: releaseTrack, at: $atLocation)
            } else {
                VStack {
                    Text("Invalid Progress Number\natLocal: \(atLocation)")
                    Button {
                        atLocation = 0
                    } label: {
                        Text("Back")
                    }
                }
                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
            }
        }
    }
    
    init(at: Binding<Int>) {
        if !AppInfo.debug {
            systemVersion = (try? call("sw_vers -productVersion")) ?? "11.xx.yy"
            print("Detected System Version: \(systemVersion)")
            _ = try? call("[[ -d ~/.patched-sur ]] || mkdir ~/.patched-sur")
            _ = try? call("[[ -e ~/.patched-sur/track.txt ]] || echo Release > ~/.patched-sur/track.txt")
            releaseTrack = (try? call("cat ~/.patched-sur/track.txt")) ?? "Release"
            print("Detected Release Track: \(releaseTrack)")
            gpu = (try? call("system_profiler SPDisplaysDataType | awk -F': ' '/^\\ *Chipset Model:/ {printf $2 \", \"}'")) ?? "INTEL!"
            gpu.removeLast(2)
            print("Detected GPU: \(gpu)")
            model = (try? call("sysctl -n hw.model")) ?? "MacModelX,Y"
            print("Detected Mac Model: \(model)")
            cpu = (try? call("sysctl -n machdep.cpu.brand_string")) ?? "INTEL!"
            print("Detected CPU: \(cpu)")
            memory = (try? call("echo \"$(($(sysctl -n hw.memsize) / 1024 / 1024 / 954))\"")) ?? "-100"
            print("Detected Memory Amount: \(memory)")
            buildNumber = (try? call("sw_vers | grep BuildVersion:")) ?? "20xyyzzz"
            if buildNumber.count > 14 {
                buildNumber.removeFirst(14)
            } else {
                AppInfo.preventUpdate = true
            }
            print("Detected macOS Build Number: \(buildNumber)")
        } else {
            if !CommandLine.arguments.contains("versionFormatted") {
                systemVersion = (try? call("sw_vers -productVersion")) ?? "11.xx.yy"
                print("Detected System Version: \(systemVersion)")
            } else {
                print("DEBUG OVERRIDE: Skipping macOS Formatted System Version Check.")
                print("Overriding System Version: 11.XX.YY")
                systemVersion = "11.XX.YY"
            }
            if !CommandLine.arguments.contains("releaseTrack") {
                releaseTrack = (try? call("cat ~/.patched-sur/track.txt")) ?? "INVALID"
                print("Detected Release Track: \(releaseTrack)")
            } else {
                print("DEBUG OVERRIDE: Skipping Patched Sur Release Track Check.")
                print("Overriding Release Track: Release")
                releaseTrack = "Release"
            }
            if !CommandLine.arguments.contains("gpuCheck") {
                gpu = (try? call("system_profiler SPDisplaysDataType | awk -F': ' '/^\\ *Chipset Model:/ {printf $2 \", \"}'")) ?? "INTEL!"
                gpu.removeLast(2)
                print("Detected GPU: \(gpu)")
            } else {
                print("DEBUG OVERRIDE: Skipping Hardware GPU Check.")
                print("Overriding GPU: Integrated HD Bug Graphics")
                gpu = "Integrated HD Bug Graphics"
            }
            if !CommandLine.arguments.contains("macModel") {
                model = (try? call("sysctl -n hw.model")) ?? "MacModelX,Y"
                print("Detected Mac Model: \(model)")
            } else {
                print("DEBUG OVERRIDE: Skipping Hardware Mac Model Check.")
                print("Overriding Mac Model: MacModelD,B")
                model = "MacModelD,B"
            }
            if !CommandLine.arguments.contains("cpuCheck") {
                cpu = (try? call("sysctl -n machdep.cpu.brand_string")) ?? "INTEL!"
                print("Detected CPU: \(cpu)")
            } else {
                print("DEBUG OVERRIDE: Skipping Hardware CPU Check.")
                print("Overriding GPU: Intel iDebug Core @ 100.3GHz")
                cpu = "Intel iDebug Core @ 100.3GHz"
            }
            if !CommandLine.arguments.contains("memoryCheck") {
                memory = (try? call("echo \"$(($(sysctl -n hw.memsize) / 1024 / 1024 / 954))\"")) ?? "-100"
                print("Detected Memory Amount: \(memory)")
            } else {
                print("DEBUG OVERRIDE: Skipping Hardware Memory Check.")
                print("Overriding Memory Amount: 10k")
                memory = "10k"
            }
            if !CommandLine.arguments.contains("buildNumber") {
                buildNumber = (try? call("sw_vers | grep BuildVersion:")) ?? "20xyyzzz"
                buildNumber.removeFirst(14)
                print("Detected macOS Build Number: \(buildNumber)")
            } else {
                print("DEBUG OVERRIDE: Skipping macOS Build Number Check.")
                print("Overriding Build Number: 20XYYZZZ")
                buildNumber = "20XYYZZZ"
            }
        }
        _atLocation = at
        print("Loading main screen.")
        print("")
    }
}

struct MainView: View {
    @State var hovered = -1
    @Binding var at: Int
    var buildNumber: String
    var model: String
    var body: some View {
        VStack {
            Text("Patched Sur")
                .font(.title2)
                .fontWeight(.heavy)
            Text("v\(AppInfo.version) (\(AppInfo.build))")
                .padding(.bottom, 3)
            HStack {
                Button {
                    withAnimation(Animation.linear(duration: 0)) {
                        if buildNumber.count >= 5 {
                            at = 1
                        } else {
                            print("Some details were failed to fetch in the inital launch sequence.")
                            print("Warning user, and attempting to recover.")
                            do {
                                try call("[[ -d ~/.patched-sur ]] || mkdir ~/.patched-sur")
                                try call("[[ -e ~/.patched-sur/track.txt ]] || echo Release > ~/.patched-sur/track.txt")
                                presentAlert(m: "Patched Sur Needs To Restart", i: "The Patched Sur app encountered a problem during launch that prevented access to some necessary data that is required during updates. Patched Sur ran some opperations that should protect against this problem, and simply restarting the app should fix this problem. When you click okay, the app will close and then you should be able to open it again and this problem will be solved.", s: .informational)
                                exit(0)
                            } catch {
                                presentAlert(m: "Patched Sur Does Not Have The Required Information To Update", i: "The Patched Sur app encountered a problem during launch that prevented access to some necessary data that is required during updates. Patched Sur ran some opperations that would protect against this problem, but these failed. This problem should rarely happen, but it did so there's not much I can do.\n\n\(error.localizedDescription)")
                            }
                        }
                    }
                } label: {
                    VStack {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("Update macOS")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background((hovered == 0) ? Color.init("AccentColor-1").opacity(0.15).cornerRadius(20) : Color.clear.opacity(0.0001).cornerRadius(20))
                    .onHover { (hovering) in
                        hovered = hovering ? 0 : -1
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(.leading, 1)
                Button {
                    if !model.hasPrefix("iMac14,") {
                        at = 2
                    } else {
                        let errorAlert = NSAlert()
                        errorAlert.alertStyle = .informational
                        errorAlert.informativeText = "You don't need to patch the kexts on Late 2013 iMacs. Big Sur is already running at full functionality."
                        errorAlert.messageText = "Patch Kexts Unnecessary"
                        errorAlert.runModal()
                    }
                } label: {
                    VStack {
                        Image(systemName: "doc.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("Patch Kexts")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background((hovered != 1) ? Color.white.opacity(0.0001).cornerRadius(20) : Color.init("AccentColor-1").opacity(0.15).cornerRadius(20))
                    .onHover(perform: { hovering in
                        hovered = hovering ? 1 : -1
                    })
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(1)
                Button {
                    at = 3
                } label: {
                    VStack {
                        Image(systemName: "info.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("About This Mac")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(hovered != 2 ? Color.white.opacity(0.0001).cornerRadius(20) : Color.init("AccentColor-1").opacity(0.15).cornerRadius(20))
                    .onHover(perform: { hovering in
                        hovered = hovering ? 2 : -1
                    })
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(.trailing, 1)
                Button {
                    at = 4
                } label: {
                    VStack {
                        Image(systemName: "command.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("Settings")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(hovered != 3 ? Color.white.opacity(0.0001).cornerRadius(20) : Color.init("AccentColor-1").opacity(0.15).cornerRadius(20))
                    .onHover(perform: { hovering in
                        hovered = hovering ? 3 : -1
                    })
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(.trailing, 1)
            }
        }.navigationTitle("Patched Sur")
    }
}
