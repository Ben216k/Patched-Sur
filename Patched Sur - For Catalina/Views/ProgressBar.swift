//
//  ProgressBar.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: CGFloat
    var length: CGFloat = 285
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().frame(minWidth: length)
                .opacity(0.3)
                .foregroundColor(Color("Accent").opacity(0.9))
            
            Rectangle().frame(width: min(value*length, length))
                .foregroundColor(Color("Accent"))
                .animation(.linear)
        }.cornerRadius(20)
    }
}
