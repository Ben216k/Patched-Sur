//
//  DoneView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/21/21.
//

import VeliaUI

struct DoneView: View {
    var body: some View {
        VStack {
            Text(.init("FINISHED"))
                .font(.system(size: 15)).bold()
            ScrollView {
                Text(.init("PRE-DONE-INFO"))
            }
            VStack(spacing: 0) {
                Button {
                    NSWorkspace.shared.open(URL(string: "https://github.com/BenSova/Patched-Sur#how-do-i-use-patched-sur")!)
                } label: {
                    Text(.init("PRE-DONE-LINK"))
                        .multilineTextAlignment(.center)
                }.buttonStyle(LinkButtonStyle())
                Text(.init("PRE-DONE-STEPS"))
            }.frame(width: 500)
        }
    }
}
