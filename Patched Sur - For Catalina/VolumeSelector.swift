//
//  VolumeSelector.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files

struct VolumeSelector: View {
    @State var volumes: [String] = []
    @Binding var pro: Int
    @State var selected = ""
    @State var hovered = ""
    @State var buttonBG = Color.accentColor
    @State var buttonBG2 = Color.secondary
    @State var showDeleteAlert = false
    var body: some View {
        VStack {
            Text("Select a USB Volume").bold()
            Text("To install MacOS Big Sur, you need to make a usb installer. This USB must be 16GB or greater to store the main os and recovery mode. If you're USB doesn't show up, click refresh to reindex the list.")
                .padding()
                .multilineTextAlignment(.center)
            HStack {
                ForEach(volumes, id: \.self) { volume in
                    Button {
                        selected = volume
                    } label: {
                        if !(volume.hasPrefix("com.apple")) {
                            if selected == volume {
                                Text(volume)
                                    .padding(8)
                                    .background(Color.secondary.opacity(0.1))
                                    .cornerRadius(10)
                                    .foregroundColor(.primary)
                            } else {
                                Text(volume)
                                    .padding(8)
                                    .background(hovered == volume ? Color.secondary.opacity(0.07) : Color.secondary.opacity(0.05))
                                    .cornerRadius(10)
                                    .onHover(perform: { hovering in
                                        if hovering {
                                            hovered = volume
                                        } else {
                                            if hovered == volume {
                                                hovered = ""
                                            }
                                        }
                                    })
                            }
                        } else {
                            EmptyView()
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                }
            }
            HStack {
                Button {
                    if selected != "" {
                        pro = 2
                    }
                } label: {
                    ZStack {
                        buttonBG
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                if !(selected == "") {
                                    buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                                }
                            })
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 10)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 10)
                .opacity(selected == "" ? 0.4 : 1)
                Button {
                    do {
                        let volumesFolder = try Folder(path: "/Volumes")
                        volumes = volumesFolder.subfolders.map(\.name)
                    }
                    catch {
                        volumes = []
                    }
                } label: {
                    ZStack {
                        buttonBG2
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                buttonBG2 = hovering ? Color.secondary.opacity(0.7) : Color.secondary
                            })
                        Text("Refresh")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 10)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.top, 10)
            }
        }
    }
    
    init(p: Binding<Int>) {
        self._pro = p
        do {
            let volumesFolder = try Folder(path: "/Volumes")
            volumes = volumesFolder.subfolders.map(\.name)
        }
        catch {
            volumes = []
        }
    }
}

struct VolumeSelector_Previews: PreviewProvider {
    static var previews: some View {
        VolumeSelector(p: .constant(1))
            .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
            .background(Color.white)
    }
}
