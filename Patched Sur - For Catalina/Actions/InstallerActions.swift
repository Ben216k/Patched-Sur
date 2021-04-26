//
//  InstallerActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import Foundation

// MARK: Extract/Move Installer

var useBeta = false

func extractPackage(installInfo: InstallAssistant, password: String, errorX: (String) -> (), beta: (String) -> ()) {
    do {
        if installInfo.buildNumber == "CustomPKG" {
            print("Cleaning up before extraction")
            _ = try? call("rm -rf '/Applications/Install macOS Big Sur.app'", p: password)
            _ = try? call("rm -rf '/Applications/Install macOS Big Sur Beta.app'", p: password)
            _ = try? call("rm -rf /Applications/PSInstaller.app", p: password)
            print("Checking before-hand SHA Sums")
            let betaSHA = try? call("shasum -a 1 /Applications/Install\\ macOS\\ Big\\ Sur\\ Beta.app/Contents/MacOS/InstallAssistant | cut -d \" \" -f 1")
            print("Extracting Package at \(installInfo.url)")
            try call("installer -pkg '\(installInfo.url)' -target /", p: password)
            print("Checking back at SHA Sums")
            let betaSHANew = try? call("shasum -a 1 /Applications/Install\\ macOS\\ Big\\ Sur\\ Beta.app/Contents/MacOS/InstallAssistant | cut -d \" \" -f 1")
            if betaSHA != betaSHANew {
                useBeta = true
            }
        } else {
            if installInfo.url != "/Applications/Install macOS Big Sur.app" && installInfo.url != "/Applications/Install macOS Big Sur Beta.app" {
                print("Checking installer type")
                useBeta = (try? call("cat '\(installInfo.url)/Contents/Info.plist' | grep 'Install macOS Big Sur Beta'")) != nil
                print("Cleaning up before move.")
                _ = try? call("rm -rf '/Applications/Install macOS Big Sur\(useBeta ? " Beta" : "").app'", p: password)
                print("Moving installer app")
                try call("cp -a '\(installInfo.url)' '/Applications/Install macOS Big Sur\(useBeta ? " Beta" : "").app'", p: password)
                print("Done moving this app for this dumb workaround that I have to use for dumb reasons.")
            } else if installInfo.url == "/Applications/Install macOS Big Sur Beta.app" {
                useBeta = true
            }
        }
        print("Note: Using \(useBeta ? "Beta" : "Release") scheme.")
        errorX("CREATE")
    } catch {
        print("Failed to extract package.")
        errorX(error.localizedDescription)
    }
}

// MARK: Create Install Media

func createInstallMedia(volume: String, installInfo: InstallAssistant, password: String, progressText: @escaping (String) -> (), errorX: (String) -> ()) {
    do {
        progressText("Temporarily disabling Spotlight indexing")
        print("Disabling bad Spotlight Indexing")
        _ = try? call("launchctl disable system/com.apple.displaypolicyd", p: password)
        _ = try? call("launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
        print("Stopping mds...")
        _ = try? call("killall mds", p: password)
        _ = try? call("killall mds_stores", p: password)
        print("Sleeping real quick")
        progressText("Sleeping for a second")
        _ = try? call("sleep 2")
        print("Force unmounting the volume...")
        progressText("Force unmounting the volume")
        do {
            let diskID = try call("df '/Volumes/\(volume)' | tail -1 | sed -e 's@ .*@@'")
            try call("diskutil unmount force '\(diskID)'")
            do {
                try call("diskutil mount '\(diskID)'")
            } catch {
                errorX("Failed to remount drive.")
                return
            }
        } catch {}
        print("Sleeping again")
        progressText("Sleeping again")
        _ = try? call("sleep 2")
        print("Starting createinstallmedia")
        progressText("Starting createinstallmedia")
        try call("/Applications/Install\\ macOS\\ Big\\ Sur\(useBeta ? "\\ Beta" : "").app/Contents/Resources/createinstallmedia --volume '/Volumes/\(volume)' --nointeraction", p: password, h: progressText)
        print("Finished createinstallmedia!")
        errorX("PATCH")
    } catch {
        _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
        _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
        print("Failed to create installer media.")
        errorX(error.localizedDescription)
    }
}

// MARK: Patch Installer

func patchInstaller(password: String, progressText: @escaping (String) -> (), errorX: (String) -> ()) {
    do {
        progressText("Copying Patches to Backup Directory")
        _ = try? call("mkdir /usr/local/lib", p: password)
        _ = try? call("rm -rf ~/.patched-sur/__MACOSX", p: password)
        _ = try? call("rm -rf /usr/local/lib/__MACOSX", p: password)
        _ = try? call("rm -rf Patched-Sur-Patches*", p: password, at: "/usr/local/lib")
        if let sharedSupport = Bundle.main.sharedSupportPath, (try? call("[[ -e \(sharedSupport)/Patched-Sur-Patches.zip ]]")) != nil {
            try call("unzip \(sharedSupport)/Patched-Sur-Patches.zip -d /usr/local/lib", p: password, at: "/usr/local/lib")
        } else {
            try call("unzip ~/.patched-sur/Patched-Sur-Patches.zip -d /usr/local/lib", p: password, at: "/usr/local/lib")
        }
        try call("mv Patched-Sur-Patches-* Patched-Sur-Patches", p: password, at: "/usr/local/lib")
        _ = try? call("rm -rf ~/.patched-sur/__MACOSX", p: password)
        _ = try? call("rm -rf /usr/local/lib/__MACOSX", p: password)
        _ = try? call("echo '\(AppInfo.patchesV.version)' > /usr/local/lib/Patched-Sur-Patches/pspVersion", p: password)
        progressText("Starting USB Patch")
        print("Killing MDS again...")
        _ = try? call("killall mds", p: password)
        _ = try? call("killall mds_stores", p: password)
        print("Starting to patch USB installer")
        #if !DEBUG
        try call("/usr/local/lib/Patched-Sur-Patches/Scripts/PatchUSB.sh '\(Bundle.main.resourcePath!)'", p: password, h: progressText)
        #else
        try call("/Users/bensova/Developer/Patched-Sur-Patches/Scripts/PatchUSB.sh '\(Bundle.main.resourcePath!)'", p: password, h: progressText)
        #endif
        progressText("Copying Post-Install App")
        print("Copying Post-Install App")
        if let bundlePath = Bundle.main.path(forResource: "Patched Sur.app", ofType: nil) {
            _ = try? call("rm -rf '/Applications/Patched Sur.app'")
            try call("cp -rf \"\(bundlePath)\" '/Applications/Patched Sur.app'")
        }
        _ = try? call("cp -a \"\(Bundle.main.path(forResource: "Patched Sur.app", ofType: nil) ?? Bundle.main.bundlePath)\" /Volumes/Install\\ macOS\\ Big\\ Sur/Patched\\ Sur.app")
        _ = try? call("cp -a \"\(Bundle.main.path(forResource: "Patched Sur.app", ofType: nil) ?? Bundle.main.bundlePath)\" /Volumes/Install\\ macOS\\ Big\\ Sur\\ Beta/Patched\\ Sur.app")
        print("Successfully patched USB.")
        _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
        _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
        errorX("DONE")
    } catch {
        _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
        _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
        print("Failed to patch installer media.")
        errorX(error.localizedDescription)
    }
}
