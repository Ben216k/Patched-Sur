//
//  StartInstallView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 12/8/20.
//

import SwiftUI
import SwiftShell
import Files

struct StartInstallView: View {
    @State var correctPassword = false
    @State var password = ""
    @State var errorT = ""
    @State var buttonBG = Color.red
    @Binding var installerPath: String
    var body: some View {
        VStack {
            Text("Ready to Update!")
                .bold()
            Text("Once you enter your password, Patched Sur will finish preparing for the update and restart into the macOS Updater. After a while, macOS will be finished installing and you can patch the kexts and then enjoy macOS.")
                .padding()
                .multilineTextAlignment(.center)
            if correctPassword && errorT == "" {
                ZStack {
                    Color.secondary
                        .cornerRadius(10)
                        .frame(minWidth: 200, maxWidth: 450)
                        .onAppear(perform: {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    if !installerPath.hasSuffix("app") {
                                        print("Clean up before extraction...")
                                        _ = try? call("rm -rf ~/.patched-sur/Install\\ macOS\\ Big\\ Sur*.app")
                                        _ = try? call("rm -rf ~/.patched-sur/pkg-extract")
                                        print("Unpacking package...")
                                        if installerPath == "~/.patched-sur/InstallAssistant.pkg" {
                                            try call("cd ~/.patched-sur && pkgutil --expand-full ~/.patched-sur/InstallAssistant.pkg ~/.patched-sur/pkg-extract")
                                        } else {
                                            try call("cd ~/.patched-sur && pkgutil --expand-full '\(installerPath)' ~/.patched-sur/pkg-extract")
                                        }
                                        print("Organizing package...")
                                        try call("mv ~/.patched-sur/pkg-extract/Payload/Applications/Install\\ macOS\\ Big\\ Sur*.app ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app")
                                        try call("mkdir ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app/Contents/SharedSupport")
                                        try call("mv ~/.patched-sur/pkg-extract/SharedSupport.dmg ~/.patched-sur/Install\\ macOS\\ Big\\ Sur.app/Contents/SharedSupport")
                                        _ = try? call("rm -rf ~/.patched-sur/trash")
//                                        print("Sending keychain information to helper...")
//                                        try call("~/.patched-sur/Helper.app/Contents/MacOS/Patched\\ Sur\\ Helper -p \"\(password.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\"")
//                                        print("Unzipping Hax script...")
//                                        try call("")
                                        print("Injecting Hax...")
                                        try call("launchctl setenv DYLD_INSERT_LIBRARIES ~/.patched-sur/big-sur-micropatcher/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib")
//                                        print("Starting helper for startosinstall...")
//                                        try shellOut(to: "open ~/.patched-sur/Helper.app")
                                        print("Starting OS Install....")
                                        try call("DYLD_INSERT_LIBRARIES=~/.patched-sur/big-sur-micropatcher/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib ~/.patched-sur/Install\\ macOS\\ Big\\ Sur*.app/Contents/Resources/startosinstall --volume / --nointeraction", p: password)
//                                        print("Done, we should restart any time now...")
//                                        print("Helper started, quitting app.")
//                                        exit(0)
                                    } else {
//                                        print("Injecting Hax...")
//                                        try call("launchctl setenv DYLD_INSERT_LIBRARIES ~/.patched-sur/big-sur-micropatcher/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib")
//                                        print("Throwing app instructions...")
//                                        try call("touch ~/.patched-sur/startosinstall")
//                                        print("Restarting app...")
//                                        print("Starting OS Install...")
                                        try call("DYLD_INSERT_LIBRARIES=~/.patched-sur/big-sur-micropatcher/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib '\(installerPath)/Contents/Resources/startosinstall' --volume / --nointeraction", p: password)
//                                        print("Done, we should restart any time now...")
                                    }
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
