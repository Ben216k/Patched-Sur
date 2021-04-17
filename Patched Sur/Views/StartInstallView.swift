//
//  StartInstallView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 12/8/20.
//

import VeliaUI
import Files

struct StartInstallView: View {
    @Binding var password: String
    @State var errorT = ""
    @State var buttonBG = Color.red
    @Binding var installInfo: InstallAssistant?
    @State var currentText = ""
    
    var body: some View {
        VStack {
            Text("Ready to Update!")
                .bold()
            Text("Now, Patched Sur will finish preparing for the update and restart into the macOS Updater. After a while, macOS will be finished installing and you can patch the kexts and then enjoy macOS. This will take a while! Just like the preparing for update part of system preferences, this isn't the fastest thing in the world.")
                .padding(.vertical)
                .multilineTextAlignment(.center)
            if errorT == "" {
                VStack {
                    VIButton(id: " ", h: .constant("")) {
                        Image("UpdateCircle")
                        Text("Preparing for Update")
                    }.inPad().btColor(.gray)
                    .onAppear(perform: {
                        DispatchQueue.global(qos: .background).async {
                            AppInfo.canReleaseAttention = false
                            startOSInstall(password: password, installInfo: installInfo!, currentText: { currentText = $0 }, errorX: { errorT = $0 })
                        }
                    })
                    Text(currentText)
                        .font(.caption)
                        .frame(width: 250)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            } else {
                VIError(errorT)
            }
        }.frame(minWidth: 540, maxWidth: 540)
    }
}
