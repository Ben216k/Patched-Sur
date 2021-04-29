//
//  ReleaseTrackView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 10/16/20.
//

import VeliaUI

struct ReleaseTrackView: View {
    @Binding var track: ReleaseTrack
    @Binding var p: PSPage
    @State var hovered: String?
    let isPost: Bool
    
    var body: some View {
        VStack {
            Text(.init("PRE-TRACK-TITLE"))
                .font(.system(size: 15)).bold()
            Text(.init("PRE-TRACK-DESCRIPTION"))
                .multilineTextAlignment(.center)
                .padding(.vertical)
            HStack {
                VIButton(id: "RELEASE", h: $hovered) {
                    Image("TriUpCircle\(track != .release ? "" : "Fill")")
                    Text(.init("TRACK-RELEASE"))
                        .fontWeight(track != .release ? .regular : .heavy)
                } onClick: {
                    track = .release
                }.inPad()
                .btColor(track != .release ? .gray : .init("Accent"))
                .useHoverAccent()
                VIButton(id: "BETA", h: $hovered) {
                    Image("AntCircle\(track != .developer ? "" : "Fill")")
                    Text(.init("TRACK-BETA"))
                        .fontWeight(track != .developer ? .regular : .heavy)
                } onClick: {
                    track = .developer
                }.inPad()
                .btColor(track != .developer ? .gray : .init("Accent"))
                .useHoverAccent()
            }.padding(.bottom)
            VIButton(id: "CONTINUE", h: $hovered) {
                Text(.init("CONTINUE"))
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .macOS
                }
            }.inPad()
        }
    }
}
