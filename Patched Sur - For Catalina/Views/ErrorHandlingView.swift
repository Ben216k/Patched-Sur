//
//  ErrorHandlingView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import SwiftUI
import VeliaUI

struct ErrorHandlingView: View {
    let bubble: String
    let fullError: String
    @State var copiedError = false
    
    var body: some View {
        VStack {
            Text(bubble)
                .multilineTextAlignment(.center)
            ZStack(alignment: .bottomTrailing) {
                Color.red.opacity(0.1).cornerRadius(15)
                ScrollView(showsIndicators: false) {
                    ZStack(alignment: .topLeading) {
                        Rectangle().opacity(0.00001)
                        Text(fullError)
                            .padding(10)
                            .padding(.horizontal, 5)
                            .foregroundColor(.red)
                    }
                }
                VIButton(id: "copy-error", h: .constant("copy-error")) {
                    Text(copiedError ? "Copied Error" : "Copy Error")
                } onClick: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(fullError, forType: .string)
                    withAnimation {
                        copiedError = true
                    }
                    DispatchQueue.global(qos: .background).async {
                        sleep(1)
                        withAnimation { copiedError = false }
                    }
                }.btColor(.red)
                    .inPad()
                    .padding(.vertical, -20)

            }.frame(width: 425)
//                .padding(.bottom, 30)
                
                
        }.padding(.horizontal)
            .padding(.bottom, 10)
    }
}

//#Preview {
//    VStack {
//        Text("Verifying Stuff")
//            .font(.system(size: 17, weight: .bold))
//            .padding(.bottom, 10)
//        ErrorHandlingView(bubble: "An error has occured while checking your Mac for incompatabilities or fetching the latest version of the installer. Due to this, Patched Sur cannot continue.", fullError: "Error 1x1\nMessage: mount_apfs: volume could not be mounted: Resource busy\nmount: / System / Volumes / Update / mnt1 failed with 75\nFailed to mount underlying volume.\nOutput: Welcome to PatchKexts.sh (for Patched South)!\n\nChecking environment ...\nWe're booted into full macOS.\nConfirming patch location ...\nPatch Location: / usr / local / lib / Patched-Sur-Patches\nChecking WiFi patch configurat...")
//    }.padding(.horizontal, 10).frame(width: 550, height: 320)
//}
