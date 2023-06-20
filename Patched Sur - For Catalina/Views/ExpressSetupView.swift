//
//  ExpressSetupView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import SwiftUI

struct ExpressSetupView: View {
    @State var hasDetectedProperties = false
    
    var body: some View {
        Group {
            if hasDetectedProperties {
                ExpressContinueView()
            } else {
                
            }
        }
    }
}

struct ExpressContinueView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Express Setup")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            Text("Upgrading ") + Text("This Mac").bold() + Text(" to ") + Text("macOS Big Sur 11.7.7").bold() + Text(" using files ") + Text("sourced from Apple.").bold()
            Text("If you'd like to change any of the above information (i.e. selecting a different Mac, macOS version, or using a local copy of the installer) click Advanced. The majority of users will not need this option.")
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .padding(.horizontal)
            Spacer()
        }.padding(.bottom)
    }
}

struct ExpressLoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Loading Configuration")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            Text("Patched Sur is quickly analyzing this Mac and obtaining external information to check compatability and verify status ")
            Spacer()
        }.padding(.bottom)
    }
}
