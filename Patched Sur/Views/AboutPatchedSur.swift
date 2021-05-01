//
//  AboutPatchedSur.swift
//  Patched Sur
//
//  Created by Ben Sova on 3/9/21.
//

import VeliaUI

struct AboutPatchedSur: View {
    var body: some View {
        VStack {
            HStack {
                Image(Int.random(in: 1..<50) == 4 ? "CupcakePatches" : "PSIcon")
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading) {
                    Text("Patched Sur v\(AppInfo.version)")
                        .font(Font.title.bold())
                    Text(NSLocalizedString("PO-ATP-AUTHOR-BUILD", comment: "PO-ATP-AUTHOR-BUILD").replacingOccurrences(of: "APPBUILD", with: AppInfo.build.description))
                        .font(.title3)
                }
            }.padding(.top, -10)
            Text(NSLocalizedString("PO-ATP-DESCRIPTION", comment: "PO-ATP-DESCRIPTION").replacingOccurrences(of: "VERSIONTAG", with: AppInfo.version))
                .padding(.bottom)
            (Text(.init("PO-ATP-WHATS-NEW-QUESTION")).bold() + Text("\n\(NSLocalizedString("PO-ATP-WHATS-NEW-ANSWER", comment: "PO-ATP-WHATS-NEW-ANSWER"))"))
        }.padding(20).padding(.horizontal, 15).frame(width: 425, height: 225)
        .multilineTextAlignment(.center)
    }
}
