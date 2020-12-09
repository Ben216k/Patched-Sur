//
//  StartInstallView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 12/8/20.
//

import SwiftUI

struct StartInstallView: View {
    @State var correctPassword = false
    @State var password = ""
    @State var errorT = ""
    @State var buttonBG = Color.red
    var body: some View {
        VStack {
            Text("Ready to Update!")
                .bold()
            Text("Once you enter your password, Patched Sur will finish preparing for the update and restart into the macOS Updater. After a while, macOS will be finished installing and you can patch the kexts and then enjoy macOS.")
            if correctPassword && errorT == "" {
                ZStack {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                        .onAppear(perform: {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    print("Installing package...")
                                    try shellOut(to: "echo \(password.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")) | sudo -S installer -pkg ~/.patched-sur/InstallAssistant.pkg -target /")
                                    print("Starting OS Install...")
                                    try shellOut(to: "echo \(password.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")) | sudo -S \"/Applications/Install macOS Big Sur Beta.app/Contents/Resources/startosinstall\" --volume / --nointeraction")
                                    print("Done, we should restart any time now...")
                                } catch {
                                    errorT = error.localizedDescription
                                }
                            }
                        })
                    Text("Preparing for Update...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                }
            } else if !correctPassword {
                EnterPasswordButton(password: $password) {
                    correctPassword = true
                }
            } else {
                VStack {
                    Button {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(errorT, forType: .string)
                    } label: {
                        ZStack {
                            buttonBG
                                .cornerRadius(10)
                                .frame(minWidth: 200, maxWidth: 450)
                                .onHover(perform: { hovering in
                                    buttonBG = hovering ? Color.red.opacity(0.7) : .red
                                })
                                .onAppear(perform: {
                                    if buttonBG != .red && buttonBG != Color.red.opacity(0.7) {
                                        buttonBG = .red
                                    }
                                })
                            Text(errorT)
                                .foregroundColor(.white)
                                .lineLimit(4)
                                .padding(6)
                                .padding(.horizontal, 4)
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                    Text("Click to Copy")
                        .font(.caption)
                }.fixedSize()
            }
        }
    }
}
