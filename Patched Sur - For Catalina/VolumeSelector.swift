//
//  VolumeSelector.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import ShellOut

struct VolumeSelector: View {
    var body: some View {
        VStack {
            Text("Select a USB Volume").bold()
            Text("To install MacOS Big Sur, you need to make a usb installer. This USB must be 16GB or greater to store the main os and recovery mode. If you're USB doesn't show up, click refresh to reindex the list.")
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

struct VolumeSelector_Previews: PreviewProvider {
    static var previews: some View {
        VolumeSelector()
            .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
            .background(Color.white)
    }
}
