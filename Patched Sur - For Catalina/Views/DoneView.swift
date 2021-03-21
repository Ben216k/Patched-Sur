//
//  DoneView.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/21/21.
//

import VeliaUI

struct DoneView: View {
    var body: some View {
        VStack {
            Text("Finished")
                .font(.system(size: 15)).bold()
            ScrollView {
                Text(doneText)
            }
            HStack {
                Button {
                    NSWorkspace.shared.open(URL(string: "https://github.com/BenSova/Patched-Sur#how-do-i-use-patched-sur")!)
                } label: {
                    Text("You can also find these steps on GitHub.")
                }.buttonStyle(LinkButtonStyle())
                Text("(Steps 10-14)")
            }
        }
    }
}

fileprivate let doneText = """
You're almost there on your way upgrading to Big Sur. The installer USB has successfully been created and it's time for a little manual work from you. If you're not directly following a tutorial, write these steps down so you know to do them (these are really easy steps, even though it looks like a lot of them):

1. Restart your Mac holding down option until you see some drive appear on screen.
2. Select the yellow or purple EFI Boot. This will immediately shutdown your computer.
3. Turn your Mac back on, holding option again.
4. Select Install macOS Big Sur.
5. Once your Mac boots, select (Re)Install macOS Big Sur again. (It might sound like it, but this will not wipe any user data, it will just upgrade the system files like a standard update)
6. When that app opens, go through the app and select your main volume (probably Macintosh HD, and NOT Install macOS Big Sur)
7. After the update is complete and you see the log-in window, open your Applications folder and launch Patched Sur.
8. Click Patch Kexts, then press Continue and enter your password.
9. After that is done, reboot your Mac and enjoy Big Sur!
"""
