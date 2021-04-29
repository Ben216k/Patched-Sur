//
//  CreditsView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import VeliaUI

struct CreditsView: View {
    @Binding var p: PSPage
    @State var hovered: String?
    
    var body: some View {
        VStack {
            Text(.init("THANKS-TITLE"))
                .font(.system(size: 15)).bold()
            ScrollView {
                Text(.init("THANKS-CONTENT"))
                    .padding(.bottom, 10)
            }
            VIButton(id: "START", h: $hovered) {
                Text(.init("CONTINUE"))
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .remember
                }
            }.inPad()
        }
    }
}
