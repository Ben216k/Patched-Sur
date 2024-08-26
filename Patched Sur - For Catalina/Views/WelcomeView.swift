//
//  WelcomeView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            HStack {
//                Image("PatchedSurIcon").resizable().frame(width: 30, height: 30)
                Text(.init("PRE-WELCOME-TITLE"))
                        .font(.system(size: 17)).bold()
                        .padding(.bottom, 2)
            }
            Text(.init("NEO-PRE-WELCOME-DESCRIPTION"))
                .multilineTextAlignment(.center)
                .padding([.bottom, .horizontal])
                .padding(.horizontal)
        }
    }
}
