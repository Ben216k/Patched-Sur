//
//  main.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/29/20.
//

import Foundation

//var mainLogger = PatchedSurLogger()
//
//func print(_ string: String) {
//    print(string, to: &mainLogger)
//}

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

print("Quick check to see if we are supposed to be running statosinstall...")
if let date = UserDefaults.standard.object(forKey: "installStarted") as? Date {
    if let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute, diff < 10 {
        print("Starting OS install...")
        AppInfo.startingInstall = true
        PatchedSurOSInstallApp.main()
        exit(0)
    }
}
print("Nope! Conitnuing.")

CommandLine.arguments.forEach { arg in
    switch arg {
    case "--help", "-h":
//        print("Help mode does not exist yet...")
        print("\n--help (-h):")
        print("Shows this screen!")
//        print("--update (-u)   Starts the inapp updater (you don't need this)")
        print("--debug (-d):")
        print("  Starts the app with specific checks disabled.")
        print("--safe (-s): ")
        print("  Starts the app without showing the main prompts")
        print("  and forcing the Patch Kexts section to be shown.")
        print("--allow-reinstall (-r):")
        print("  Allow reinstalling macOS on the update macOS screen.")
        print("--force-skip-download (-p):")
        print("  Skip the download step on the macOS updater, and using")
        print("  the InstallAssistant that was already downloaded.")
        exit(0)
    case "--update", "-u":
        print("Detected --update option, starting Patched Sur update.")
        updatePatchedApp()
        exit(0)
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
    case "--safe", "-s":
        print("Detected --safe option, starting straight into Patch Kexts.")
        print("Note: all other command line options will be ignored.")
        print("")
        AppInfo.safe = true
        PatchedSurSafeApp.main()
        exit(0)
    case "--allow-reinstall", "-r":
        print("Detected --allow-reinstall option, reinstalls enabled.")
        AppInfo.reinstall = true
    case "--force-skip-download", "-pre", "-p":
        print("Detected --force-skip-download, skipping the download files step in the updater.")
        AppInfo.usePredownloaded = true
    default:
        print("Unknown option detected. Ignoring option. (Use --help to see available options)")
    }
}

PatchedSurApp.main()
