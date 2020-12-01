//
//  Patched_SurApp.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files

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

final class AppInfo {
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
    static var debug = false
}

struct PatchedSurLogger: TextOutputStream {
    var logLocation = ""

    func write(_ string: String) {
        print(string, terminator: "")
        do {
            try Folder.home.createFileIfNeeded(at: logLocation)
            let logFile = try File(path: "~/\(logLocation)")
            try logFile.append(string)
        } catch {
            print("Unable to write message to log. This is unexpected." as Any)
        }
    }

    init() {
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy-hh:mm.ss"
        let stringDate = format.string(from: Date())
        print("Log file will be stored at: ~/.patched-sur/logs/Post-\(stringDate).log" as Any)
        logLocation = ".patched-sur/logs/Post-\(stringDate).log"
    }
}
