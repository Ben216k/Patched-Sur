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
    @State var password = ""
    @State var volume = ""
    var body: some View {
        ZStack {
            if progress == 0 {
                MainView(p: $progress)
            } else if progress == 1 {
                MacCompatibility(p: $progress)
            } else if progress == 2 {
                HowItWorks(p: $progress)
            } else if progress == 3 {
                DownloadView(p: $progress)
            } else if progress == 4 {
                InstallPackageView(password: $password, p: $progress)
            } else if progress == 5 {
                VolumeSelector(p: $progress, volume: $volume)
            } else if progress == 6 {
                ConfirmVolumeView(volume: $volume, p: $progress)
            } else if progress == 7 {
                CreateInstallMedia(volume: $volume, password: $password)
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
