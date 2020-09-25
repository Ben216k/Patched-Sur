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
                NavigationLink(destination: Text("Hello World"), isActive: $mainShown) {
                    HStack {
                        Image("UpdateTab")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Updates")
                    }
                }
                NavigationLink(destination: Text("Hello World")) {
                    HStack {
                        Image("KextTab")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Patch Kexts")
                    }
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
