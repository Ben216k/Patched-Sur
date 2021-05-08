//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import VeliaUI

struct AboutMyMac: View {
    @State var systemVersion = "11.%.3"
    let releaseTrack: String
    @State var gpu = "Intel HD Graphics 400%"
    @State var coolModel = "MacBook Pro (13-inch, M%d 2012)" as String?
    @State var model = "MacBookPro%,2"
    @State var cpu = "Intel(R) Core(TM) i5-3210M CPU"
    @State var memory = "1%"
    let buildNumber: String
    @Binding var at: Int
    @State var hovered: String?
    
    var body: some View {
        ZStack {
            BackGradientView(releaseTrack: releaseTrack)
            HStack {
                SideImageView(releaseTrack: releaseTrack)
                VStack(alignment: .leading, spacing: 2) {
                    Text("macOS ").font(.largeTitle).bold() + Text("Big Sur").font(.largeTitle)
                    Text("\(NSLocalizedString("PO-AMM-VERSION", comment: "PO-AMM-VERSION")) \(systemVersion)\(buildNumber.count < 8 ? "" : " Beta") (\(buildNumber))").font(.subheadline)
                        .redacted(reason: systemVersion.contains("%") ? .placeholder : .init())
                    Rectangle().frame(height: 15).opacity(0).fixedSize()
                    if let coolModel = coolModel {
                        Text(coolModel).font(.subheadline).bold()
                            .redacted(reason: coolModel.contains("%") ? .placeholder : .init())
                    }
                    HStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            Text(.init("PO-AMM-MODEL")).font(.subheadline).bold()
                            Text(.init("PO-AMM-PROCESSOR")).font(.subheadline).bold()
                            Text(.init("PO-AMM-GRAPHICS")).font(.subheadline).bold()
                            Text(.init("PO-AMM-MEMORY")).bold()
                        }
                        VStack(alignment: .leading) {
                            Text(model)
                                .redacted(reason: model.contains("%") ? .placeholder : .init())
                            Text(cpu)
                                .redacted(reason: cpu.contains("%") ? .placeholder : .init())
                            Text(gpu)
                                .redacted(reason: gpu.contains("%") ? .placeholder : .init())
                            Text("\(memory) GB")
                                .redacted(reason: memory.contains("%") ? .placeholder : .init())
                        }
                    }
                    HStack {
                        VIButton(id: "HOME", h: $hovered) {
                            Text(.init("PO-AMM-BACK"))
                                .foregroundColor(.white)
                        } onClick: {
                            withAnimation {
                                at = 0
                            }
                        }.inPad()
                        .btColor(releaseTrack == "Developer" ? .init(r: 196, g: 0, b: 255) : .init(r: 0, g: 220, b: 239))
                        VIButton(id: "SOFTWARE", h: $hovered) {
                            Text(.init("PO-AMM-UPDATE"))
                                .foregroundColor(.white)
                        } onClick: {
                            withAnimation {
                                at = 1
                            }
                        }.inPad()
                        .btColor(releaseTrack == "Developer" ? .init(r: 196, g: 0, b: 255) : .init(r: 0, g: 220, b: 239))
                    }.padding(.top, 10)
                }.font(.subheadline)
                .foregroundColor(.white)
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        withAnimation {
                            systemVersion = (try? call("sw_vers -productVersion")) ?? "11.xx.yy"
                            print("Detected System Version: \(systemVersion)")
                            self.model = (try? call("sysctl -n hw.model")) ?? "UnknownX,Y"
                            cpu = (try? call("sysctl -n machdep.cpu.brand_string")) ?? "INTEL!"
                            cpu = String(cpu.split(separator: "@")[0])
                            print("Detected CPU: \(cpu)")
                            gpu = (try? call("system_profiler SPDisplaysDataType | awk -F': ' '/^\\ *Chipset Model:/ {printf $2 \", \"}'")) ?? "INTEL!"
                            gpu.removeLast(2)
                            print("Detected GPU: \(gpu)")
                            memory = (try? call("echo \"$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024))\"")) ?? "-100"
                            print("Detected Memory Amount: \(memory)")
                            guard let newModel = try? call("curl -s 'https://support-sp.apple.com/sp/product?cc='$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 9-) | sed 's|.*<configCode>\\(.*\\)</configCode>.*|\\1|'") else {
                                coolModel = nil
                                return
                            }
                            coolModel = newModel
                        }
                    }
                }
            }
        }
    }
    
    init(releaseTrack: String, model model2: String, buildNumber: String, at: Binding<Int>) {
        self.releaseTrack = releaseTrack
        self.buildNumber = buildNumber
        self._at = at
    }
}

extension Color {
    init(
        r red: Int,
        g green: Int,
        b blue: Int,
        o opacity: Double = 1
    ) {
        self.init(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: opacity
        )
    }
}

struct SideImageView: View {
    let releaseTrack: String
    let scale: CGFloat
    var body: some View {
        if releaseTrack == "Beta" || releaseTrack == "Developer" {
            Image("BigSurLake")
                .resizable()
                .scaledToFit()
                .frame(width: scale, height: scale)
                .padding()
        } else {
            Image("BigSurSafari")
                .resizable()
                .scaledToFit()
                .frame(width: scale, height: scale)
                .padding()
        }
    }
    
    init(releaseTrack: String, scale: CGFloat = 140) {
        self.releaseTrack = releaseTrack
        self.scale = scale
    }
}

struct BackGradientView: View {
    @Environment(\.colorScheme) var colorScheme
    let releaseTrack: String
    var body: some View {
        if releaseTrack == "Developer" {
            LinearGradient(gradient: .init(colors: [.init(r: 196, g: 0, b: 255), .init(r: 117, g: 0, b: 255)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(colorScheme == .dark ? 0.7 : 0.96)
//        } else if releaseTrack == "Developer" {
//            LinearGradient(gradient: .init(colors: [.init(r: 237, g: 36, b: 5), .init(r: 254, g: 110, b: 16)]), startPoint: .bottomLeading, endPoint: .topTrailing)
//                .opacity(colorScheme == .dark ? 0.5 : 0.96)
        } else {
            LinearGradient(gradient: .init(colors: [.init(r: 0, g: 220, b: 239), .init(r: 5, g: 229, b: 136)]), startPoint: .leading, endPoint: .trailing)
                .opacity(colorScheme == .dark ? 0.7 : 0.96)
                .background(Color.black)
        }
    }
}

// Anything, pretend that instead of the whole expression, it shows only the normal value you are supposed to put there, that's what you replace light or dark with, a normal value for light or a normal value for dark. Another way to think of it, is that imagine that the `colorScheme == .dark ? varA : varB` is an `if` statement for a single value (which it is), if this is true use this value otherwise use this other value.
