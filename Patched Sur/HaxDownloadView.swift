//
//  HaxDownloadView.swift
//  Patched Sur
//
//  Created by Ben Sova on 1/29/21.
//

import SwiftUI

struct HaxDownloadView: View {
    @State var errorT = ""
    let installInfo: InstallAssistant?
    var body: some View {
        VStack {
            Text("Starting Installer Enviorment")
                .bold()
            Text("Since the installer checks to make sure your Mac is supported, we need to skip this check to make sure you can actually update macOS. To do this, we need to use ASentientBot's Hax.dylib to skip this check. As soon as this is done, the app will close and reopen then the updater will continue.")
                .padding()
            ZStack {
                Color.secondary
                    .cornerRadius(10)
                    .frame(minWidth: 200, maxWidth: 450)
                    .onAppear(perform: {
                        DispatchQueue.global(qos: .background).async {
                            do {
                                print("Downloading Hax...")
                                try call("curl -Lo HaxDoNotSeal.dylib https://github.com/barrykn/big-sur-micropatcher/raw/main/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib", at: "~/.patched-sur")
                                print("Confirming Hax permissions...")
                                try call("chmod u+x ~/.patched-sur/HaxDoNotSeal.dylib")
                                print("Injecting Hax...")
                                try call("launchctl setenv DYLD_INSERT_LIBRARIES ~/.patched-sur/HaxDoNotSeal.dylib")
                                print("Saving app instructions...")
                                UserDefaults.standard.set(Date(), forKey: "installStarted")
                                UserDefaults.standard.set(try! installInfo!.jsonString()!, forKey: "installInfo")
                                print("Restarting app...")
                                try call("open \"\(CommandLine.arguments[0])\"")
                                exit(0)
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
            }.fixedSize()
        }
    }
}
