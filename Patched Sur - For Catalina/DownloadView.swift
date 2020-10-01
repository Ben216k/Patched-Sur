//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files

struct DownloadView: View {
    @State var downloadStatus = "Starting Download..."
    @State var setVarsTool: Data?
    @State var setVarsZip: File?
    @State var setVarsSave: Folder?
    @Binding var p: Int
    
    var body: some View {
        VStack {
            Text("Downloading Set Vars Tool and Kext Patches").bold()
            Text("The set vars tool allows you to properly setup the nvram and sip status, so that Big Sur let's you boot into it. This is the last tool you use before installing Big Sur. The kext patches allow you to use stuff like WiFi and USB ports, so that your Mac stays at full functionality.")
                .padding(10)
                .multilineTextAlignment(.center)
            ZStack {
                Color.secondary
                    .cornerRadius(10)
                    .frame(minWidth: 200, maxWidth: 450)
                if downloadStatus == "Starting Download..." {
                    Text("Starting Download...")
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .onAppear {
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    let appDir = try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
                                    if (try? appDir.subfolder(named: "big-sur-micropatcher")) != nil {
                                        try shellOut(to: "git pull", at: "~/.patched-sur/big-sur-micropatcher")
                                    } else {
                                        try shellOut(to: "git clone https://github.com/barrykn/big-sur-micropatcher.git", at: "~/.patched-sur")
                                        _ = try appDir.subfolder(named: "big-sur-micropatcher")
                                    }
                                    p = 4
                                } catch {
                                    downloadStatus = error.localizedDescription
                                }
                            }
                        }
                        .padding(6)
                        .padding(.horizontal, 4)
                } else {
                    Text(downloadStatus)
                        .foregroundColor(.white)
                        .lineLimit(4)
                        .padding(6)
                        .padding(.horizontal, 4)
                        .onTapGesture {
                            NSPasteboard.general.setString(downloadStatus, forType: .string)
                        }
                }
            }
            .fixedSize()
        }
    }
}

struct InstallAssistantView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView(p: .constant(2))
            .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
            .background(Color.white)
    }
}
