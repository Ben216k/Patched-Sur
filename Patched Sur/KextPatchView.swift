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
                        try shellOut(to: "echo \"\(password)\" | sudo -S \"/Install macOS Big Sur Beta/patch-kext.sh\"")
                    } catch {
                        isCorrect = false
                    }
                }
            }
            TextField("Password...", text: $password)
                .padding()
                .background(isCorrect ? Color.green : .red)
            Button("Check Password") {
                if password != "" {
                    do {
                        try shellOut(to: "echo \"\(password)\" | sudo -S echo Hi")
//                        try shellOut(to: "sudo echo Hi")
                        isCorrect = true
                    } catch let error as ShellOutError {
                        isCorrect = false
                        password = error.localizedDescription
                    } catch {
                        isCorrect = false
                        password = "Uh-oh"
                    }
                }
            }
        }
    }
}
