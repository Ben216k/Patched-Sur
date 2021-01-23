//
//  ReleaseTrackView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 10/16/20.
//

import SwiftUI

struct ReleaseTrackView: View {
    @Binding var track: ReleaseTrack
    @Binding var p: Int
    @State var hovered = nil as String?
    var body: some View {
        VStack {
            Text("Set Update Track")
                .bold()
            Group {
                switch track {
                case .release:
                    Text("Your update track is what versions of macOS updates you get. The \"release\" update track contains the official macOS updates that you normally get with a Mac when updating. These versions of macOS are the most stable.")
                case .publicbeta:
                    Text("Your update track is what versions of macOS updates you get. The \"public beta\" update track contains the unstable beta macOS updates that are designed for public use, but not distribution uses because these updates are still buggy.")
                case .developer:
                    Text("Your update track is what versions of macOS updates you get. The \"developer\" update track contains the latest macOS features, so developers can prepare for public use. This track is the most unstable of them all, but still can be stable at times.")
                }
            }.multilineTextAlignment(.center)
            .padding()
            HStack {
                Button {
                    track = .release
                } label: {
                    if track == .release {
                        Text("Release")
                            .padding(8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    } else {
                        Text("Release")
                            .padding(8)
                            .background(track == .release ? Color.secondary.opacity(0.07) : Color.secondary.opacity(0.05))
                            .cornerRadius(10)
                    }
                }.buttonStyle(BorderlessButtonStyle())
                Button {
                    track = .publicbeta
                } label: {
                    if track == .publicbeta {
                        Text("Public Beta")
                            .padding(8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    } else {
                        Text("Public Beta")
                            .padding(8)
                            .background(track == .publicbeta ? Color.secondary.opacity(0.07) : Color.secondary.opacity(0.05))
                            .cornerRadius(10)
                    }
                }.buttonStyle(BorderlessButtonStyle())
                Button {
                    track = .developer
                } label: {
                    if track == .developer {
                        Text("Developer")
                            .padding(8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    } else {
                        Text("Developer")
                            .padding(8)
                            .background(track == .developer ? Color.secondary.opacity(0.07) : Color.secondary.opacity(0.05))
                            .cornerRadius(10)
                    }
                }.buttonStyle(BorderlessButtonStyle())
            }
            HStack {
                Button {
                    p = 2
                } label: {
                    ZStack {
                        (hovered == "BACK" ? Color.secondary.opacity(0.7) : Color.secondary)
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                hovered = hovering ? "BACK" : nil
                            })
                        Text("Back")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 10)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    p = 10
                } label: {
                    ZStack {
                        (hovered == "CONTINUE" ? Color.accentColor.opacity(0.7) : Color.accentColor)
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                hovered = hovering ? "CONTINUE" : nil
                            })
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 10)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.top, 10)
        }
    }
}
