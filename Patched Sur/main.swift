//
//  main.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/29/20.
//

import Foundation

var mainLogger = PatchedSurLogger()

func print(_ string: String) {
    print(string, to: &mainLogger)
}

print("Hello! If you're seeing this, you are seeing the logs of Patched Sur!")
print("Or maybe running this from the command line...")
print("")
print("Patched Sur v\((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "x.y.z") Build \(Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-100") ?? -100)")
#if DEBUG
print("Running From Xcode in DEBUG configuration.")
#else
print("Running Either Normally or From Terminal in RELEASE configuration.")
#endif
print("")
if CommandLine.arguments.count > 1 {
    switch CommandLine.arguments[1] {
    case "--update", "-u":
        print("Detected --update option, starting Patched Sur update.")
        updatePatchedApp()
    case "--debug", "-d":
        print("Detected --debug option, starting DEBUG mode.")
        print("\n==========================================\n")
        print("With debug mode, you can disable many features within the app to try to diagnose crashes.\n")
        print("You can disable any of the following:")
        print("versionFormatted\nreleaseTrack\ngpuCheck\nmacModel\ncpuCheck\nmemoryCheck\nbuildNumber")
        print("\nTo disable on of these, type it's name after the debug option, for example:\n")
        print("/path/to/patched-sur/binary --debug buildNumber memoryCount")
        print("\nYou can have any number of disabled options, just separate them with spaces.")
        print("All keys must be spelt right, otherwise they will be ignored.")
        print("\n==========================================\n")
        AppInfo.debug = true
        print("Starting normal Patched Sur with debug changes...")
        print("")
        PatchedSurApp.main()
    case "--safe", "-s":
        print("Detected --safe option, starting straight into Patch Kexts.")
        AppInfo.safe = true
        PatchedSurSafeApp.main()
    default:
        print("Unknown option detected. Defaulting to normal mode.")
        PatchedSurApp.main()
    }
} else {
    print("No options detected. Defaulting to normal mode.")
    PatchedSurApp.main()
}
