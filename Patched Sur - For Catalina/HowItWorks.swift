//
//  HowItWorks.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct HowItWorks: View {
    @Binding var p: Int
    @State var buttonBG = Color.accentColor
    var body: some View {
        VStack {
            Text("How it Works").bold()
            ScrollView {
                Text(howItWorks)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            Button {
                p = 9
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 50)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }.padding()
    }
}

struct HowItWorks_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorks(p: .constant(3))
    }
}

let howItWorks = """
How about I do this later? I need to focus on the app right now. That's fair, right? Well, yeah. I do appreciate my beta testers, but I'm not going to write paragraph after paragraph about how this app works, if they are just going to click Continue. I'll do it later.

Beta 2... or..

Maybe a different beta... or..

How about before the release? Yeah, that's good.
"""
