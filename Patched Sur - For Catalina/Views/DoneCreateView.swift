//
//  DoneCreateView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 10/26/23.
//

import VeliaUI

struct DoneView: View {
    var body: some View {
        VStack {
            Text(.init("FINISHED"))
                .font(.system(size: 15)).bold()
            ScrollView {
                Text(.init("PRE-DONE-INFO")).padding(.horizontal)
            }
        }
    }
}
