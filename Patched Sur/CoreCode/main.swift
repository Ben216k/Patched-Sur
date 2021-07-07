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

//fatalError()

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

print("Checking if we want to fix v0.1.0 deprecated values...")
if (try? call("[[ -e ~/.patched-sur/track.txt ]]", at: ".")) != nil {
    print("We're switching to the new stuff!")
    UserDefaults.standard.setValue((try? call("cat ~/.patched-sur/track.txt")) ?? "Release", forKey: "UpdateTrack")
    _ = try? call("rm -rf ~/.patched-sur/track.txt", at: ".")
}

print("Checking if we want to fix v0.2.0 deprecated values...")
if UserDefaults.standard.string(forKey: "UpdateTrack") == "Public Beta" {
    print("We're switching to the new stuff!")
    UserDefaults.standard.setValue("Developer", forKey: "UpdateTrack")
}

print("Checking for Metal")
if let metalStatus = try? call("system_profiler SPDisplaysDataType | grep Metal"), !metalStatus.contains(": Supported") {
    AppInfo.openGL = true
}

print("Checking for lol")
if (try? call("nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:PSVersion")) != nil {
    AppInfo.lol = true
}

UserDefaults.standard.setValue(true, forKey: "OverrideLateiMacChecks")
print(UserDefaults.standard.bool(forKey: "OverrideLateiMacChecks"))

//print(UserDefaults.standard.)

CommandLine.arguments.forEach { arg in
    switch arg {
    case "--help", "-h":
        print("\n--help (-h):")
        print("Shows this screen!")
        print("--safe (-s): ")
        print("  Starts the app without showing the main prompts")
        print("  and forcing the Patch Kexts section to be shown.")
        print("--allow-reinstall (-r):")
        print("  Allow reinstalling macOS on the update macOS screen.")
        print("--force-skip-download (-p):")
        print("  Skip the download step on the macOS updater, and using")
        print("  the InstallAssistant that was already downloaded.")
        print("--daemon (-d):")
        print("  Runs the Patched Sur update daemon. Perferably this")
        print("  should only be done by launchctl.")
        print("--update (-u):")
        print("  Runs the app updater. This assumes that a copy of")
        print("  Patched Sur is inside the ~/.patched-sur directory.")
        print("--nothing (-n):")
        print("  Make the app do almost nothing. Certain things will")
        print("  still be done. This is useful for typechecking.")
        exit(0)
    case "--update", "-u":
        print("Detected --update option, starting Patched Sur update.")
        updatePatchedApp()
        exit(0)
    case "--safe", "-s":
        print("Detected --safe option, starting straight into Patch Kexts.")
        print("Note: all other command line options will be ignored.")
        print("")
        AppInfo.safe = true
        PatchedSurSafeApp.main()
        exit(0)
    case "--daemon", "-d":
        print("Detected --daemon option, starting straight into the update checker.")
        print("Note: all other command line options will be ignored.")
        patchDaemon()
        exit(0)
    case "--allow-reinstall", "-r":
        print("Detected --allow-reinstall option, reinstalls enabled.")
        AppInfo.reinstall = true
    case "--force-skip-download", "-pre", "-p":
        print("Detected --force-skip-download, skipping the download files step in the updater.")
        AppInfo.usePredownloaded = true
    case "--nothing", "-n":
        print("Detected --nothing, we're not actually going to do anything today.")
        AppInfo.nothing = true
    case "-AppleLanguages":
        print("Running with a custom language.")
    default:
        print("Unknown option (\(arg)) detected. Ignoring option. (Use --help to see available options)")
    }
}

PatchedSurApp.main()
