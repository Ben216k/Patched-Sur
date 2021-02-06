//
//  ConfirmVolume.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct ConfirmVolumeView: View {
    @Binding var volume: String
    @Binding var p: Int
    @State var buttonBG = Color.red
    @State var buttonBG2 = Color.secondary
    var body: some View {
        VStack {
            Text("\(volume) Will Be Erased").bold()
            (Text("Are you sure you would like to continue and erase \(volume)? This process will remove ") + Text("all").italic() + Text(" data files and folders on this drive (including other partitions), in favor of the macOS installer. Are you sure you would like to continue?"))
                .padding()
                .multilineTextAlignment(.center)
            HStack {
                Button {
                    withAnimation {
                        p = 5
                    }
                } label: {
                    ZStack {
                        buttonBG2
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                buttonBG2 = hovering ? Color.secondary.opacity(0.7) : Color.secondary
                            })
                        Text("Back")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 10)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                Button {
                    withAnimation {
                        p = 7
                    }
                } label: {
                    ZStack {
                        buttonBG
                            .cornerRadius(10)
                            .onHover(perform: { hovering in
                                buttonBG = hovering ? Color.red.opacity(0.7) : Color.red
                            })
                        Text("Continue")
                            .foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal, 10)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}
