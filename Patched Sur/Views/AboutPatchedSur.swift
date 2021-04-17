//
//  AboutPatchedSur.swift
//  Patched Sur
//
//  Created by Ben Sova on 3/9/21.
//

import VeliaUI

struct AboutPatchedSur: View {
    var body: some View {
        VStack {
            HStack {
                Image("PSIcon")
                VStack(alignment: .leading) {
                    Text("Patched Sur v\(AppInfo.version) Beta")
                        .font(Font.title.bold())
                    Text("By: Ben Sova • Build \(AppInfo.build)")
                        .font(.title3)
                }
            }.padding(.top, -10)
            Text("A simple patcher, with a big core, to make running Big Sur on an unsupported Mac easy.")
                .padding(.bottom)
            (Text("What's in v0.2.0?").bold() + Text("\nLet's just say it's cleaned up. It's redesigned. It's recovered. It's Patched Sur, but it fixes what's missing."))
        }.padding(20).padding(.horizontal, 15).frame(width: 425, height: 225)
        .multilineTextAlignment(.center)
    }
}
