//
//  StartOSInstallApp.swift
//  StartOSInstall
//
//  Created by Ben Sova on 1/19/21.
//

import SwiftUI
import SwiftShell

struct PatchedSurHelperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var errorX: String?
    var body: some Scene {
        WindowGroup {
            ZStack {
                VisualEffectView()
                if let errorX = errorX {
                    VStack {
                        Button {
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(errorX, forType: .string)
                        } label: {
                            ZStack {
                                Color.red
                                    .cornerRadius(10)
                                    .frame(minWidth: 200, maxWidth: 320)
                                Text(errorX)
                                    .foregroundColor(.white)
                                    .lineLimit(4)
                                    .padding(6)
                                    .padding(.horizontal, 4)
                            }.frame(minWidth: 200, maxWidth: 320)
                        }.buttonStyle(BorderlessButtonStyle())
                        Text("Click to Copy")
                            .font(.caption)
                    }
                } else {
                    VStack {
                        Text("Starting Update of macOS").bold()
                        Text("Your computer will automatically start the update and restart once it is ready.")
                            .padding([.horizontal, .top])
                            .multilineTextAlignment(.center)
                            .onAppear {
                                DispatchQueue.global(qos: .background).async {
                                    do {
                                        print("[PSH] Obtaining keychain data...")
                                        guard let passwordData = KeyChain.load(key: "bensova.Patched-Sur.userpass") else {
                                            print("[PSH] Failed to fetch password.")
                                            errorX = "Failed to read data from keychain."
                                            return
                                        }
                                        print("[PSH] Translating data into strings...")
                                        guard let password = String(data: passwordData, encoding: .utf8) else {
                                            print("[PSH] Failed to convert data to string.")
                                            errorX = "Failed to convert data to string"
                                            return
                                        }
                                        print("[PSH] Starting OS Install")
                                        try runAndPrint(bash: "echo \(password.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")) | sudo -S ~/.patched-sur/Install\\ macOS\\ Big\\ Sur*.app/Contents/Resources/startosinstall --volume / --nointeraction")
                                    } catch {
                                        errorX = error.localizedDescription
                                    }
                                }
                            }
                    }
                }
            }.ignoresSafeArea()
            .frame(width: 300, height: 100)
        }.windowStyle(HiddenTitleBarWindowStyle())
    }
}

CommandLine.arguments.forEach { arg in
    switch arg {
    case "-p":
        print("[PSH] Instructed to save password to keychain.")
        print("[PSH] Obtaining string...")
        let password = CommandLine.arguments[2]
        print("[PSH] Converting String to Data...")
        guard let passwordData = password.data(using: .utf8) else {
            print("[PSH] Failed to convert string to data!")
            print("[PSH] [Note] This is not a patcher bug.")
            exit(112)
        }
        print("[PSH] Attempting to save data to keychain...")
        if KeyChain.save(key: "bensova.Patched-Sur.userpass", data: passwordData) != noErr {
            print("[PSH] Failed to save data to keychain!")
            exit(113)
        }
        print("[PSH] Saved data to keychain!")
        print("[PSH] Sending success back to patcher...")
        exit(0)
    default:
        break
    }
}

PatchedSurHelperApp.main()
