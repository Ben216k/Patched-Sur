//
//  PatchKextsView.swift
//  Patched Sur
//
//  Created by Ben Sova on 3/24/21.
//

import VeliaUI

struct PatchKextsView: View {
    @State var hovered: String?
    @Binding var at: Int
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                VIHeader(p: "Patch Kexts", s: "Make Drivers Work Basically")
                    .alignment(.leading)
                Spacer()
                VIButton(id: "BACK", h: $hovered) {
                    Image(systemName: "chevron.backward.circle")
                    Text("Back")
                } onClick: {
                    at = 0
                }.inPad()
            }.padding(.top, 40)
            Spacer()
            Text("Patch Kexts")
                .font(.system(size: 15)).bold()
            Text("Patching your kexts gets you Wifi, USB, and many other things working on your Big Sur installation. Without these kexts, your Mac would not be at its full potential on Big Sur, and several things would not work. If you need to, you can unpatch the kexts then repatch them which might solve a problem. Sometimes, it might be a good idea to wait a little bit before running patch kexts, since some things might be interfering with the System volume.")
                .multilineTextAlignment(.center)
                .padding(.vertical)
            Spacer()
        }.padding(.horizontal, 30)
    }
}
