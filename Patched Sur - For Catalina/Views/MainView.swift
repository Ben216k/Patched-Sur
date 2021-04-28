//
//  MainView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import VeliaUI

struct MainView : View {
    @Binding var hovered: String?
    @Binding var p: PSPage
    @Binding var c: Bool
    
    var body: some View {
        VStack() {
//            Text("Welcome to Patched Sur!")
            Text(.init("PRE-WELCOME-TITLE"))
                .font(.system(size: 15)).bold()
            Text(.init("PRE-WELCOME-DESCRIPTION"))
                .multilineTextAlignment(.center)
                .padding(.vertical)
            VIButton(id: "START", h: $hovered) {
                Text(.init("GET-STARTED"))
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .credits
                    c = true
                }
            }.inPad()
        }
    }
}
