//
//  main.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 12/1/20.
//

import Foundation
import AppKit

print("Hello! If you're seeing this, you are seeing the logs of (pre-install) Patched Sur!")
print("Or maybe running this from the command line...")
print("")
print("Patched Sur v\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "x.y.z") Build \(Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-100") ?? -100)")
#if DEBUG
print("Running From Xcode in DEBUG configuration.")
#else
print("Running Either Normally or From Terminal in RELEASE configuration.")
print("Checking for Patched Sur dmg...")
if (try? shellOut(to: "[[ -d /Volumes/Patched-Sur ]]")) == nil {
    print("Patched Sur DMG is not mounted.")
    let errorAlert = NSAlert()
    errorAlert.alertStyle = .critical
    errorAlert.informativeText = "This app is not designed to be placed inside your Applications folder or left without the Patched Sur DMG. When the time comes for the app to be in your Applications folder, Patched Sur will move a special copy of the app into your Applications folder that is designed to run without this DMG.\n\nOpen the Patched Sur dmg (if you moved the app to the Applications folder, delete it) and double click on the app inside the DMG to run the patcher."
    errorAlert.messageText = "Patched Sur DMG Not Detected"
    errorAlert.runModal()
    exit(1)
}
#endif
print("")
print("Starting App Delegate.")
AppDelegate.main()
