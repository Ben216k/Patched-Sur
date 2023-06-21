//
//  SelectVolumeView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import VeliaUI

struct SelectVolumeView: View {
    @Binding var volume: String
    @State var hovered: String?
    @State var volumeList: [String]?
    @State var incompatibleList = [] as [(title: String, reason: String)]
    @State var onVol = ""
    @State var alert: Alert?
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ZStack(alignment: .bottom) {
                    VStack {
                        Spacer()
                        Text(.init("PRE-VOL-TITLE"))
                            .font(.system(size: 17, weight: .bold))
                            .padding(.bottom, 10)
                        Text("\(NSLocalizedString("PRE-VOL-1", comment: "PRE-VOL-1")) \(NSLocalizedString("PRE-VOL-3", comment: "PRE-VOL-3"))")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        if volumeList == [] {
                            VStack {
                                HStack {
                                    VIButton(id: "NODRIVES", h: $hovered) {
                                        Image("ExclaimCircle")
                                        Text(.init("PRE-VOL-NO"))
                                    }.btColor(.red)
                                    .inPad()
                                    VIButton(id: "REFRESH", h: $hovered) {
                                        Image("RefreshCircle")
                                        Text(.init("REFRESH"))
                                    } onClick: {
                                        volumeList = nil
                                    }.btColor(.gray)
                                    .inPad()
                                    .useHoverAccent()
                                }
                            }.padding(.bottom, 30)
                        } else if let volumes = volumeList {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(volumes, id: \.self) { name in
                                        VIButton(id: name, h: $hovered) {
                                            Text(name)
                                                .fontWeight(volume == name ? .bold : .regular)
                                        } onClick: {
                                            volume = name
                                        }.btColor(volume == name ? .init("Accent") : .gray)
                                        .useHoverAccent()
                                        .inPad()
                                    }
                                }
                            }.frame(maxWidth: 520).fixedSize(horizontal: true, vertical: false)
                                .padding(.bottom, 0.1)
                            HStack {
                                VIButton(id: "REFRESH-EXCESSIVE-TEXT", h: $hovered) {
                                    Image("RefreshCircle")
                                    Text(.init("REFRESH"))
                                } onClick: {
                                    volumeList = nil
                                }.btColor(.gray)
                                .inPad()
                                .padding(.bottom, 5)
                            }.alert(isPresented: .init(get: { alert != nil }, set: { _ in alert = nil })) {
                                alert ?? Alert(title: Text("An Error Occurred"), message: Text("Something went wrong and an error cannot be provided."))
                            }
                        } else {
                            VStack {
                                VIButton(id: "NEVER-HOVERED", h: .constant("MUHAHAHA")) {
                                    Image("DriveCircle")
                                    Text(.init("PRE-VOL-DETECTING"))
                                }.inPad()
                                    .btColor(.gray)
                                    .onAppear {
                                        DispatchQueue(label: "DetectVolumes", qos: .userInteractive).async {
                                            let output = detectVolumes(onVol: { onVol = $0 })
                                            volumeList = output.compat
                                            incompatibleList = output.incompat
                                            if !(volumeList?.contains(volume) ?? true) {
                                                if (volumeList?.filter { $0.hasPrefix("Install macOS") }.count ?? 0) > 0 {
                                                    volume = volumeList!.reversed().filter { $0.hasPrefix("Install macOS") }[0]
                                                } else if volumeList?.count == 1 {
                                                    volume = volumeList![0]
                                                }
                                            }
                                        }
                                    }
                                Text(NSLocalizedString("PRE-VOL-CHECKING", comment: "PRE-VOL-CHECKING").description.replacingOccurrences(of: "VOLUME", with: onVol))
                                    .font(.caption)
                            }
                        }
                        Spacer()
                    }
                    if volumeList == [] {
                        VStack {
                            Text("See Incompatible Drives")
                                .padding(.bottom, -7)
                            Image("ForwardArrow")
                                .rotationEffect(.init(degrees: 90))
                                .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        }.foregroundColor(.secondary)
                    }
                }.frame(height: geo.size.height)
                if volumeList == [] {
                    ForEach(incompatibleList, id: \.title) { item in
                        Text("").padding(.top, 5)
                        HStack {
                            ZStack {
                                Color.red
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                                Image("VolumeIcon")
                                    .foregroundColor(.white)
                                    .offset(x: -0.001, y: -0.1)
                            }
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .bold()
                                Text(item.reason)
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 10))
                            }
                            Spacer()
                        }.padding(.bottom, 0.001)
                        Divider()
                    }.padding(.horizontal)
                    Text("").padding(.bottom, 50)
                }
            }
        }
    }
}
