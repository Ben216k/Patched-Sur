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
        if CommandLine.arguments.count > 1 {
            switch CommandLine.arguments[1] {
            case "--update", "-u":
                break
            case "--safe", "-s":
                PatchedSurSafeApp.main()
            default:
                PatchedSurApp.main()
            }
        } else {
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
