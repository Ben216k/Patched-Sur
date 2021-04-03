//
//  CreditsView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import VeliaUI

struct CreditsView: View {
    @Binding var p: PSPage
    @State var hovered: String?
    
    var body: some View {
        VStack {
            Text("Thanks To")
                .font(.system(size: 15)).bold()
            ScrollView {
                Text(creditsText)
                    .padding(.bottom, 10)
            }
            VIButton(id: "START", h: $hovered) {
                Text("Continue")
                Image("ForwardArrowCircle")
            } onClick: {
                withAnimation {
                    p = .remember
                }
            }.inPad()
        }
    }
}

fileprivate let creditsText = """
Patched Sur isn't just by me (Ben), several other people have contributed to the patcher and the patches making this what it is today!

- barrykn: Made the micropatcher that introduced me to the patching process and restored my faith in my really old computer. My hat is off to barrykn, and yours should be too.
- ASentientBot: Made the Hax patches for the installer and brought GeForce Tesla (9400M/320M) framebuffer to Big Sur
- jackluke: Figured out how to bypass compatibility checks on the installer USB.
- highvoltage12v: Made the first WiFi kexts used with Big Sur
- ParrotGeek: developed the LegacyUSBInjector kext to get USB ports working on some older Macs and figuring out a way to skip the terminal commands when opening the installer app on the USB.
- testheit: Helped with the kmutil command in the micropatcher (that is used in Patched Sur too)
- Ausdauersportler: Integrated patches for iMac Metal GPU support.
- StarPlayrX: Pointed out startosinstall which was later used in the patcher to allow macOS updating support without a USB.
- ASentientHedgehog: Helped randomly along the way
- John_val, fromeister2009, Mr. Macintosh, Emperor Epitaph, Finder352, Monkiey and AvaQueen for testing some of the new features before release, and pointing out the bugs with them.
- and several others who helped with making Big Sur run as great as it does on unsupported Macs.

Patched Sur also uses two Open Source frameworks, Files and ShellOut by JohnSundell (MIT), to help handle certain tasks.
"""
