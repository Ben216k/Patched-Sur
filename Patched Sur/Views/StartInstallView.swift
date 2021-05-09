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
            Text(.init("PO-UP-SOI-TITLE"))
                .bold()
            Text(.init("PO-UP-SOI-DESCRIPTION"))
                .padding(.vertical)
                .multilineTextAlignment(.center)
            if errorT == "" {
                VStack {
                    VIButton(id: " ", h: .constant("")) {
                        Image("UpdateCircle")
                        Text(.init("PO-UP-SOI-PREPARING"))
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
