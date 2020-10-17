//
//  ContentView.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct ContentView: View {
    @State var mainShown = true
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Updates"), isActive: $mainShown) {
                    Label("Updates", systemImage: "arrow.clockwise")
                        .padding(3)
                }
                NavigationLink(destination: KextPatchView()) {
                    Label("Patch Kexts", systemImage: "doc")
                        .padding(3)
                }
            }.listStyle(SidebarListStyle())
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
