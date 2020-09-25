//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct DownloadView: View {
    @State var downloadStatus = "Starting Download..."
    @State var setVarsTool: Data?
    var body: some View {
        VStack {
            Text("Downloading Set Vars Tool and Kext Patches").bold()
            Text("The set vars tool allows you to properly setup the nvram and sip status, so that Big Sur let's you boot into it. This is the last tool you use before installing Big Sur. The kext patches allow you to use stuff like WiFi and USB ports, so that your Mac stays at full functionality.\n\n\(downloadStatus)")
                .padding()
                .multilineTextAlignment(.center)
            ZStack {
                Color.secondary
                    .cornerRadius(10)
                    .frame(width: 200)
                Text(downloadStatus)
                    .foregroundColor(.white)
                    .lineLimit(10)
                    .onAppear {
                        if downloadStatus == "Starting Download..." {
                            do {
                                let info = try Data(contentsOf: URL(string: "https://github.com/barrykn/big-sur-micropatcher/archive/main.zip")!)
                            } catch {
                                downloadStatus = error.localizedDescription
                                return
                            }
                            downloadStatus = "Saving Files..."
                        } else if downloadStatus == "Saving Files..." {
                            downloadStatus = "Hello World"
                        }
                    }
                    .padding(6)
                    .padding(.horizontal, 4)
            }
//            .fixedSize()
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
            .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
            .background(Color.white)
    }
}
