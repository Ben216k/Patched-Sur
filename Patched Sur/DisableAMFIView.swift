//
//  DisableAMFIView.swift
//  Patched Sur
//
//  Created by Ben Sova on 1/22/21.
//

import SwiftUI

struct DisableAMFIView: View {
    @State var password = ""
    var body: some View {
        VStack {
            Text("Disable AMFI")
                .bold()
            Text("Since the installer checks to see if the update supports your Mac, Patched Sur needs to inject a dylib into it so that the installer doesn't care about the incompatibilty. However, this can only be done with AMFI off, so Patched Sur will quickly turn this off then restart your Mac, so then you can continue with updating.").padding()
                .multilineTextAlignment(.center)
            EnterPasswordButton(password: $password) {
                do {
                    var current = (try? call("nvram boot-args")) ?? "boot-args    -no_compat_check"
                    current.removeFirst("boot-args    ".count)
                    try call("nvram boot-args=\"\(current) amfi_get_out_of_my_way=1\"", p: password)
                } catch {
                    print("Failed to update NVRAM.")
                    presentAlert(m: "Failed to update boot-args", i: "Patched Sur was unable to update your boot-args. If you want to do it yourself,  run nvram boot-args=\"-no_compat_check amfi_get_out_of_my_way=1\" in terminal. Yes, you are telling AMFI to get out of your way. After that, restart then run Patched Sur again.", s: .warning)
                }
                do {
                    try call("reboot", p: password)
                } catch {
                    print("Failed to reboot, telling the user to do it themself.")
                    presentAlert(m: "Failed to Reboot", i: "You can do it yourself! Cmd+Control+Eject (or Cmd+Control+Power if you want it to be faster) will reboot your computer, or you can use the Apple logo in the corner of the screen. Your choice, they all work.", s: .warning)
                }
            }
        }
    }
}
