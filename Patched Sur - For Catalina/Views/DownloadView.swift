//
//  DownloadView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import VeliaUI
import Files

struct DownloadKextsView: View {
    @State var downloadStatus = "Downloading Files..."
    @State var setVarsTool: Data?
    @State var setVarsZip: File?
    @State var setVarsSave: Folder?
    @Binding var p: PSPage
    @State var buttonBG = Color.red
    @State var downloadSize = 55357820
    @State var downloadProgress = CGFloat(0)
    @State var currentSize = 10
    @Binding var hasKexts: Bool
    let timer = Timer.publish(every: 0.50, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Downloading Patches")
                .font(.system(size: 15)).bold()
            Text("The set vars tool allows you to properly setup the NVRAM and SIP status, so that Big Sur lets you boot into it. This is the last tool you will use before installing Big Sur. The kext patches allow you to use hardware like WiFi and USB ports, so that your Mac stays at its full functionality.")
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
            ZStack {
                if downloadStatus == "Downloading Files..." {
                    ProgressBar(value: $downloadProgress, length: 200)
                        .onReceive(timer, perform: { _ in
                            if let sizeCode = try? call("stat -f %z ~/.patched-sur/big-sur-micropatcher.zip") {
                                currentSize = Int(Float(sizeCode) ?? 10000)
                                downloadProgress = CGFloat(Float(sizeCode) ?? 10000) / CGFloat(downloadSize)
                            }
                        })
                    HStack {
                        Image("DownloadArrow")
                        Text("Downloading Files...")
                            .onAppear {
                                DispatchQueue.global(qos: .background).async {
                                    if hasKexts == true {
                                        withAnimation {
                                            p = .package
                                        }
                                        return
                                    }
                                    kextDownload(size: { downloadSize = $0 }, next: {
                                        hasKexts = true
                                        withAnimation {
                                            p = .package
                                        }
                                    }, errorX: { downloadStatus = $0 })
                                }
                            }
                            .padding(.vertical, 7)
                    }.foregroundColor(.white)
                } else {
                    VIError(downloadStatus)
                }
            }
            .fixedSize()
        }
    }
}
