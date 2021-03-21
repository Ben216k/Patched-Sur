//
//  RememberPleaseView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import VeliaUI

struct RememberPleaseView: View {
    @Binding var p: PSPage
    @State var hovered: String?
    
    var body: some View {
        VStack {
            Text("Please Remember")
                .font(.system(size: 15)).bold()
            (Text("Patched Sur is currently in beta and it will never be perfect. While it will not brick your Mac, it can cause you to lose your data if you don't have a backup.") + Text(" No matter what, make a Time Machine Backup before upgrading. ").bold() + Text("I (and contributors) will not be liable if something goes wrong. I will go to the best of my abilities to help if there is a problem, but I don't know everything and there are some cases where I cannot help. A lot of times, it isn't even Patched Sur's fault, so there's nothing I can do."))
//                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            VIButton(id: "CONTINUE5", h: $hovered) {
                Text("Continue")
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .verify
                }
            }.inPad()
        }
    }
}
