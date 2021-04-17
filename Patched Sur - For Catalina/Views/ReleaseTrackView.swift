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
            Text("Set Update Track")
                .font(.system(size: 15)).bold()
            Text("Your update track defines what versions of macOS get. The Release track is the most stable, and probably what you're using already. Beta gives you access to new features of macOS early, but it's unstable at times.\(isPost ? " Currently with this install of Patched Sur, you are using the \(UserDefaults.standard.string(forKey: "UpdateTrack") ?? "Release") track." : "")")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            HStack {
                VIButton(id: "RELEASE", h: $hovered) {
                    Image("TriUpCircle\(track != .release ? "" : "Fill")")
                    Text("Release")
                        .fontWeight(track != .release ? .regular : .heavy)
                } onClick: {
                    track = .release
                }.inPad()
                .btColor(track != .release ? .gray : .init("Accent"))
                .useHoverAccent()
                VIButton(id: "BETA", h: $hovered) {
                    Image("AntCircle\(track != .developer ? "" : "Fill")")
                    Text("Beta")
                        .fontWeight(track != .developer ? .regular : .heavy)
                } onClick: {
                    track = .developer
                }.inPad()
                .btColor(track != .developer ? .gray : .init("Accent"))
                .useHoverAccent()
            }.padding(.bottom)
            VIButton(id: "CONTINUE", h: $hovered) {
                Text("Continue")
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .macOS
                }
            }.inPad()
        }
    }
}
