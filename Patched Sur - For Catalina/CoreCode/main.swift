//
//  main.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 12/1/20.
//

import Foundation
import AppKit
import Security

print("Hello! If you're seeing this, you are seeing the logs of (pre-install) Patched Sur!")
print("Or maybe running this from the command line...")
print("")
print("Patched Sur v\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "x.y.z") Build \(Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-100") ?? -100)")
#if DEBUG
print("Running From Xcode in DEBUG configuration.")
#else
print("Running Either Normally or From Terminal in RELEASE configuration.")
print("Making sure that 100% we have what we want...")
_ = try? call("mkdir ~/.patched-sur", at: ".")
#endif
print("")
print("App Path: \(Bundle.main.bundlePath)")
print("Resource Path: \(Bundle.main.resourcePath!)")
if let sharedPath = Bundle.main.sharedSupportPath {
    print("SharedSupport Path: \(sharedPath)")
} else {
    print("SharedSupport unavailable, patches will be downloaded later.")
}
print("")
print("Starting App Delegate.")
AppDelegate.main()
