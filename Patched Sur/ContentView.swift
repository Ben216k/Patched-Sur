//
//  ContentView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var atLocation = 0
    let systemVersion: String
    let releaseTrack: String
    var gpu: String
    var model: String
    var cpu: String
    var memory: String
    var buildNumber: String
    var body: some View {
        ZStack {
            colorScheme == .dark ? Color.black : Color.white
            if atLocation == 0 {
                MainView(at: $atLocation)
            } else if atLocation == 1 {
                VStack {
                    Text("Updating is currently supported in post-install Patched Sur")
                    Button {
                        atLocation = 0
                    } label: {
                        Text("Back")
                    }
                }.navigationTitle("Patched Sur")
            } else if atLocation == 2 {
                KextPatchView(at: $atLocation)
            } else if atLocation == 3 {
                AboutMyMac(systemVersion: systemVersion, releaseTrack: releaseTrack, gpu: gpu, model: model, cpu: cpu, memory: memory, buildNumber: buildNumber, at: $atLocation)
            } else if atLocation == 4 {
                Settings(releaseTrack: releaseTrack, at: $atLocation)
            } else {
                VStack {
                    Text("Invalid Progress Number\natLocal: \(atLocation)")
                    Button {
                        atLocation = 0
                    } label: {
                        Text("Back")
                    }
                }
            }
        }
    }
    
    init() {
        systemVersion = (try? shellOut(to: "sw_vers -productVersion")) ?? "11.xx.yy"
        releaseTrack = (try? shellOut(to: "cat ~/.patched-sur/track.txt")) ?? "INVALID"
        gpu = (try? shellOut(to: "system_profiler SPDisplaysDataType | awk -F': ' '/^\\ *Chipset Model:/ {printf $2 \", \"}'")) ?? "INTEL!"
        gpu.removeLast(2)
        model = (try? shellOut(to: "sysctl -n hw.model")) ?? "MacModelX,Y"
        cpu = (try? shellOut(to: "sysctl -n machdep.cpu.brand_string")) ?? "INTEL!"
        memory = (try? shellOut(to: "echo \"$(($(sysctl -n hw.memsize) / 1024 / 1024 / 954))\"")) ?? "-100"
        buildNumber = (try? shellOut(to: "sw_vers | grep BuildVersion:")) ?? "20xyyzzz"
        buildNumber.removeFirst(14)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(minWidth: 650, maxWidth: 650, minHeight: 350, maxHeight: 350)
            .background(Color.white)
    }
}

struct MainView: View {
    @State var hovered = -1
    @Binding var at: Int
    var body: some View {
        VStack {
            Text("Patched Sur")
                .font(.title2)
                .fontWeight(.heavy)
            HStack {
                Button {
                    at = 1
                } label: {
                    VStack {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("Update macOS")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background((hovered == 0) ? Color.secondary.opacity(0.25).cornerRadius(20) : Color.clear.opacity(0.0001).cornerRadius(20))
                    .onHover { (hovering) in
                        hovered = hovering ? 0 : -1
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(.leading, 1)
                Button {
                    at = 2
                } label: {
                    VStack {
                        Image(systemName: "doc.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("Patch Kexts")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background((hovered != 1) ? Color.white.opacity(0.0001).cornerRadius(20) : Color.secondary.opacity(0.25).cornerRadius(20))
                    .onHover(perform: { hovering in
                        hovered = hovering ? 1 : -1
                    })
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(1)
                Button {
                    at = 3
                } label: {
                    VStack {
                        Image(systemName: "info.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("About This Mac")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(hovered != 2 ? Color.white.opacity(0.0001).cornerRadius(20) : Color.secondary.opacity(0.25).cornerRadius(20))
                    .onHover(perform: { hovering in
                        hovered = hovering ? 2 : -1
                    })
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(.trailing, 1)
                Button {
                    at = 4
                } label: {
                    VStack {
                        Image(systemName: "command.circle")
                            .font(Font.system(size: 90).weight(.ultraLight))
                        Text("Settings")
                            .font(.title3)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(hovered != 3 ? Color.white.opacity(0.0001).cornerRadius(20) : Color.secondary.opacity(0.25).cornerRadius(20))
                    .onHover(perform: { hovering in
                        hovered = hovering ? 3 : -1
                    })
                }
                .buttonStyle(BorderlessButtonStyle())
//                .padding(.trailing, 1)
            }
        }.navigationTitle("")
    }
}
