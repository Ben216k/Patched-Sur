//
//  ContentView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var atLocation = 0
    var body: some View {
        ZStack {
            colorScheme == .dark ? Color.black : Color.white
            if atLocation == 0 {
                MainView(at: $atLocation)
            } else if atLocation == 1 {
                VStack {
                    Text("Invalid Progress Number\natLocal: \(atLocation)")
                    Button {
                        atLocation = 0
                    } label: {
                        Text("Back")
                    }
                }
            } else if atLocation == 2 {
                KextPatchView(at: $atLocation)
            } else {
                VStack {
                    Text("Invalid Progress Number\natLocal: \(atLocation)")
                    Button {
                        atLocation = 0
                    } label: {
                        Text("Back")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(minWidth: 650, maxWidth: 650, minHeight: 350, maxHeight: 350)
            .background(Color.white)
    }
}

struct MainView: View {
    @State var hovered: Bool?
    @Binding var at: Int
    var body: some View {
        HStack {
            Button {
                at = 1
            } label: {
                VStack {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(Font.system(size: 100).weight(.ultraLight))
                    Text("Updates macOS")
                        .font(.title3)
                }
                .foregroundColor(.primary)
                .padding()
                .background((hovered ?? false) ? Color.secondary.opacity(0.25).cornerRadius(20) : Color.clear.opacity(0.0001).cornerRadius(20))
                .onHover { (hovering) in
                    hovered = hovering ? true : nil
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding()
            Button {
                at = 2
            } label: {
                VStack {
                    Image(systemName: "doc.circle")
                        .font(Font.system(size: 100).weight(.ultraLight))
                    Text("Patch Kexts")
                        .font(.title3)
                }
                .foregroundColor(.primary)
                .padding()
                .background((hovered ?? true) ? Color.white.opacity(0.0001).cornerRadius(20) : Color.secondary.opacity(0.25).cornerRadius(20))
                .onHover(perform: { hovering in
                    hovered = hovering ? false : nil
                })
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding()
        }
    }
}
