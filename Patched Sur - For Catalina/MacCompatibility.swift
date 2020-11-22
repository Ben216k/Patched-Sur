//
//  MacCompatibility.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct MacCompatibility: View {
    @Binding var p: Int
    @State var buttonBG = Color.accentColor
    var body: some View {
        VStack {
            Text("Mac Compatibility").bold()
            Text("I haven't set this up yet, so continue at your own risk, but you'll probably be fine.")
                .padding()
                .multilineTextAlignment(.center)
            Button {
                p = 2
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
        }
    }
}
