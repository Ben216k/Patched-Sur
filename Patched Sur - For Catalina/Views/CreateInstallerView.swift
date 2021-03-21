//
//  CreateInstallerView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import VeliaUI

struct CreateInstallerView: View {
    @Binding var p: PSPage
    @State var errorX = "CREATE"
    @Binding var password: String
    @Binding var showPass: Bool
    @State var hovered: String?
    
    var body: some View {
        VStack {
            Text("Creating USB Installer")
                .font(.system(size: 15)).bold()
            Text("Now the USB you selected is being used to create a macOS installer USB. The files copied on the disk create an environment similar to macOS Big Sur Recovery Mode. Once those files are placed on the USB, Patched Sur steps in and patches it allowing for your Mac to boot into it and giving it some useful tools for a patched Mac.")
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            if password == "" || showPass {
                VIButton(id: "REQUEST-ROOT", h: $hovered) {
                    Text("Request Root Permissions")
                } onClick: {
                    withAnimation {
                        showPass = true
                    }
                }.inPad()
                .btColor(.accentColor)
                .onAppear {
                    withAnimation(Animation.default.delay(0.25)) {
                        showPass = true
                        
                    }
                }.animation(.none)
            } else if errorX == "CREATE" {
                VIButton(id: "NEVER-HAPPENING", h: .constant("MUHAHAHA")) {
                    Image("DriveCircle")
                    Text("Creating Installer")
                }.inPad()
                .btColor(.gray)
            }
        }
    }
}
