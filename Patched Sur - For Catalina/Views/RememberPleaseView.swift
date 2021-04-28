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
            Text(.init("PLEASE-REMEMBER"))
                .font(.system(size: 15)).bold()
            (Text(.init("PRE-PR-1")) + Text(.init("PRE-PR-2")).bold() + Text(.init("PRE-PR-3")))
//                .font(.caption)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
            VIButton(id: "CONTINUE5", h: $hovered) {
                Text(.init("CONTINUE"))
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .verify
                }
            }.inPad()
        }
    }
}
