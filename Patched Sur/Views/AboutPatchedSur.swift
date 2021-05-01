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
            Text("A simple patcher, with a big core, to make running Big Sur on an unsupported Mac easy, designed for anyone.")
                .padding(.bottom)
            (Text("What's in v0.3.0?").bold() + Text("\nIt's going to be fast, powerful, and clear for everyone, even if you're non-Metal or non-English."))
        }.padding(20).padding(.horizontal, 15).frame(width: 425, height: 225)
        .multilineTextAlignment(.center)
    }
}
