//
//  Patched_SurApp.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

@main
struct PatchedSurStartup {
    static func main() {
        print("Hello! If you're seeing this, you are seeing the logs of Patched Sur!")
        print("Or maybe running this from the command line...")
        print("")
        print("Patched Sur v\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "x.y.z") Build \(Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-100") ?? -100)")
        #if DEBUG
        print("Running From Xcode in DEBUG configuration.")
        #else
        print("Running Either Normally or From Terminal in RELEASE configuration.")
        #endif
        print("")
        if CommandLine.arguments.count > 1 {
            switch CommandLine.arguments[1] {
            case "--update", "-u":
                print("Detected --update option, starting Patched Sur update.")
                updatePatchedApp()
            case "--safe", "-s":
                print("Detected --safe option, starting straight into Patch Kexts.")
                AppInfo.safe = true
                PatchedSurSafeApp.main()
            default:
                print("Unknown option detected. Defaulting to normal mode.")
                PatchedSurApp.main()
            }
        } else {
            print("No options detected. Defaulting to normal mode.")
            PatchedSurApp.main()
        }
    }
}

struct PatchedSurApp: App {
    @State var atLocation = 0
    var body: some Scene {
        WindowGroup {
            ContentView(at: $atLocation)
//                .frame(minWidth: 600, maxWidth: 600, minHeight: atLocation != 1 ? 325 : 249, maxHeight: atLocation != 1 ? 325 : 249)
                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
        }
    }
}

struct PatchedSurSafeApp: App {
    var body: some Scene {
        WindowGroup {
            KextPatchView(at: .constant(-11))
                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
        }
    }
}


extension Color {
    static let background = Color("Background")
    static let secondaryBackground = Color("BackgroundSecondary")
    static let tertiaryBackground = Color("BackgroundTertiary")
}

class AppInfo {
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let build = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
    static let micropatcher = { () -> String in
        print("Looking for latest Micropatcher version...")
        guard let micropatchers = try? MicropatcherRequirements(fromURL: "https://bensova.github.io/patched-sur/micropatcher.json") else {
            print("No versions found, defaulting to v0.5.0")
            return "0.5.0"
        }
        print("Found Micropatcher List!")
        let micropatcher = micropatchers.filter { $0.patcher <= Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)! }.last!
        print("Detected Micropatcher Version \(micropatcher.version)")
        return micropatcher.version
    }()
    static var safe = false
}
