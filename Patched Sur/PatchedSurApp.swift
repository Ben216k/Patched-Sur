//
//  Patched_SurApp.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

@main
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

extension Color {
    static let background = Color("Background")
    static let secondaryBackground = Color("BackgroundSecondary")
    static let tertiaryBackground = Color("BackgroundTertiary")
}
