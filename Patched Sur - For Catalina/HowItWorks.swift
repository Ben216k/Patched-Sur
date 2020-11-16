//
//  HowItWorks.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct HowItWorks: View {
    @Binding var p: Int
    @State var buttonBG = Color.accentColor
    var body: some View {
        VStack {
            Text("How it Works").bold()
            ScrollView {
                Text(howItWorks)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            Button {
                p = 9
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 50)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }.padding()
    }
}

struct HowItWorks_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorks(p: .constant(3))
    }
}

let howItWorks = """
Hi everyone! It's me BenSova again and I wanted to have a little chat with you guys.

I started noticing that people don't understand how little credit I deserve. I wrote this app to take the concepts of the micropatcher and give it a user-friendly UI. So, no, I did not make the kexts, I did not discover *any* of the tricks that are used to get past macOS's checks, not even the EFI Boot or really anything along those lines. I made it into an app.

Are you ready for the actual list (that was definitely not stolen from the micropatcher's readme)?

- ASentientBot: Made the Hax patches for the installer and brought GeForce Tesla (9400M/320M) framebuffer to Big Sur
- jackluke: Figured out how to bypass compatibility checks on the installer USB.
- highvoltage12v: Made the first WiFi kexts used with Big Sur
- ParrotGeek: developed the LegacyUSBInjector kext to get USB ports working on some older Macs and figuring out a way to skip the terminal commands when opening the installer app on the USB.
- testheit: Helped with the kmutil command in the micropatcher (that is used in Patched Sur too)
- barrykn: Made the micropatcher that introduced me to the patching process and restored my faith in my really old computer. My hat is down to barrykn, and yours should be too.
- and several others who helped with making Big Sur run as great as it does on unsupported Macs.

See? I did not include myself in that list for a reason. I wanted to make it easier for you, and that's all I accomplished. I'm not one of the crazy smart people that figured this all out, I am the one bringing it to you. As much as I appreciate all of the thanks I've been getting, I can't take that much credit (also quick question, how do you properly reply to a thanks, I use no problem, but it never sounds right).

Now, on how it works... that I'm not going to work on (yet)!

"""
