//
//  KextPatchView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/14/20.
//

import SwiftUI
import Files

struct KextPatchView: View {
    @State var password = ""
    @State var isCorrect = false
    var body: some View {
        VStack {
            Text("This is my kext patch")
            Button("Install Kext Patches") {
                DispatchQueue.global(qos: .background).async {
                    do {
                        try shellOut(to: "echo \"\(password)\" | sudo -S \"/Volumes/Install macOS Big Sur Beta/patch-kext.sh\"")
                    } catch {
                        isCorrect = false
                    }
                }
            }
            SecureField("Password...", text: $password)
                .padding(10)
                .background(isCorrect ? Color.green : .red)
                .padding(.horizontal, 60)
            Button("Check Password") {
                if password != "" {
                    do {
                        try shellOut(to: "echo \"\(password)\" | sudo -S echo Hi")
                        isCorrect = true
                    } catch {
                        isCorrect = false
                        password = ""
                    }
                }
            }
        }
    }
}
