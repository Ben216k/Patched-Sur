//
//  BuildPatchingView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import SwiftUI

struct BuildPatchInstallerView: View {
    @Binding var installInfo: InstallAssistant?
    @Binding var volume: String
    @State var errorX: String?
    
    var body: some View {
        VStack {
            Spacer()
            Text("Creating Installer USB")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 10)
            if let errorX {
                ErrorHandlingView(bubble: "An error occured fetching the list of installers for macOS Big Sur or the link to the patches to be used by this patcher. Please check your network connection and try again.", fullError: errorX)
            } else {
                Text("Patched Sur is quickly analyzing this Mac to check compatability and obtaining information about the latest macOS and patch version. This should be quick.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
            }
            Spacer()
        }
    }
}
