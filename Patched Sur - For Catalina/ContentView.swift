//
//  ContentView.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI

struct ContentView: View {
    @State var progress = 0
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Group {
            if progress == 0 {
                MainView(p: $progress)
            } else if progress == 1 {
                VolumeSelector(p: $progress)
            } else if progress == 2 {
                DownloadView(p: $progress)
            } else {
                VStack {
                    Text("Uh-oh! Something went wrong while running Patched Sur.").bold()
                    Text("Please report this problem to u/BenSova on Reddit.")
                        .padding()
                    Text("Error 001x\(progress): Invalid Progress Marking").padding([.horizontal, .bottom])
                }
            }
        }
        .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
