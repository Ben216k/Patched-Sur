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
                p = 3
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    Text("Start")
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
This is how it works. A full, longer description will be provided
"""
