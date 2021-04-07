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
    @State var onVol = ""
    @State var alert: Alert?
    @Binding var onExit: () -> (BackMode)
    let isPost: Bool
    
    var body: some View {
        VStack {
            Text("Select A USB Volume")
                .font(.system(size: 15)).bold()
            Text("\(isPost ? "To install patched Big Sur initially, you need a USB install that will assist with the upgrade. This provides an environment where the patcher can be sure that everything will go properly." : "To create an installer, you need a volume to put the installer on.") This USB needs to be 16GB or bigger. Internal partitions won't work, but external partitions do depending on the partition map (which will probably be correct with the GUID Partition Map). If your drive doesn't show up, make sure it is formatted as MacOS Extended (Journaled).")
                .padding(.vertical, 10)
                .multilineTextAlignment(.center)
            if volumeList == [] {
                VIButton(id: "NODRIVES", h: $hovered) {
                    Image("ExclaimCircle")
                    Text("No compatible drives were detected.")
                }.btColor(.red)
                .inPad()
                VIButton(id: "REFRESH", h: $hovered) {
                    Image("RefreshCircle")
                    Text("Refresh")
                } onClick: {
                    volumeList = nil
                }.btColor(.gray)
                .inPad()
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
                        Text("Refresh")
                    } onClick: {
                        volumeList = nil
                    }.btColor(.gray)
                    .inPad()
                    if volumeList!.contains(volume) {
                        VIButton(id: "CONTINUE-EXCESSIVE-TEXT", h: $hovered) {
                            Text("Continue")
                            Image("ForwardArrowCircle")
                        } onClick: {
                            alert = .init(title: Text("\(volume) will be erased."), message: Text("All the files on this volume will be completely erased. This cannot be undone. Are you sure you would like to continue?"), primaryButton: .default(Text("Continue and Erase")) { withAnimation { p = .create } }, secondaryButton: .cancel())
                        }.inPad()
                    }
                }.alert($alert)
            } else {
                VStack {
                    VIButton(id: "NEVER-HOVERED", h: .constant("MUHAHAHA")) {
                        Image("DriveCircle")
                        Text("Detecting Volumes")
                    }.inPad()
                    .btColor(.gray)
                    .onAppear {
                        DispatchQueue(label: "DetectVolumes", qos: .userInteractive).async {
                            volumeList = detectVolumes(onVol: { onVol = $0 })
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
                    Text("Checking \"\(onVol)\"")
                        .font(.caption)
                }
            }
        }
        .frame(width: 540)
    }
}
