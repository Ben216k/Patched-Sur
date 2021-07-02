//
//  VolumeSelectorView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/19/21.
//

import VeliaUI

struct VolumeSelector: View {
    @Binding var p: PSPage
    @Binding var volume: String
    @State var hovered: String?
    @State var volumeList: [String]?
    @State var incompatibleList = [] as [(title: String, reason: String)]
    @State var onVol = ""
    @State var alert: Alert?
    @Binding var onExit: () -> (BackMode)
    let isPost: Bool
    @State var showIncompat = false
    
    var body: some View {
        VStack {
            if !showIncompat {
                Text(.init("PRE-VOL-TITLE"))
                    .font(.system(size: 15)).bold()
                Text("\(isPost ? NSLocalizedString("PRE-VOL-1", comment: "PRE-VOL-1") : NSLocalizedString("PRE-VOL-2", comment: "PRE-VOL-2")) \(NSLocalizedString("PRE-VOL-3", comment: "PRE-VOL-3"))")
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)
            }
            if showIncompat {
                Text(.init("PRE-VOL-INCOMPAT-TITLE"))
                    .font(.system(size: 15)).bold()
                ScrollView(showsIndicators: false) {
                    ForEach(incompatibleList, id: \.title) { item in
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
                        }
                    }
                }
                HStack {
                    VIButton(id: "BACKINCOMPAT", h: $hovered) {
                        Image("BackArrowCircle")
                        Text(.init("BACK"))
                    } onClick: {
                        showIncompat.toggle()
                    }.btColor(.gray).inPad().useHoverAccent()
                    VIButton(id: "REFRESH", h: $hovered) {
                        Image("RefreshCircle")
                        Text(.init("REFRESH"))
                    } onClick: {
                        volumeList = nil
                        showIncompat.toggle()
                    }
                    .inPad()
                }
            } else if volumeList == [] {
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
                    VIButton(id: "SEEINCOMPAT", h: $hovered) {
                        Text(.init("PRE-VOL-INCOMPAT"))
                    } onClick: {
                        showIncompat.toggle()
                    }.btColor(.gray).inPad().useHoverAccent()
                }
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
                .padding(.bottom, 10)
                HStack {
                    VIButton(id: "REFRESH-EXCESSIVE-TEXT", h: $hovered) {
                        Image("RefreshCircle")
                        Text(.init("REFRESH"))
                    } onClick: {
                        volumeList = nil
                    }.btColor(.gray)
                    .inPad()
                    if volumeList!.contains(volume) {
                        VIButton(id: "CONTINUE-EXCESSIVE-TEXT", h: $hovered) {
                            Text(.init("CONTINUE"))
                            Image("ForwardArrowCircle")
                        } onClick: {
                            alert = .init(title: Text(NSLocalizedString("PRE-VOL-ERASED", comment: "PRE-VOL-ERASED").description.replacingOccurrences(of: "VOLUME", with: volume)), message: Text(.init("PRE-VOL-ERASED-2")), primaryButton: .default(Text(.init("CONTINUE-ERASE"))) { withAnimation { p = .create } }, secondaryButton: .cancel())
                        }.inPad()
                    }
                }.alert($alert)
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
                            onExit = { .confirm }
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
        }
        .frame(width: 540)
    }
}
