//
//  InstallerActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import Foundation

// MARK: Extract/Move Installer

func extractPackage(installInfo: InstallAssistant, password: String, errorX: (String) -> (), beta: (String) -> ()) {
    do {
        if installInfo.buildNumber == "CustomPKG" {
            print("Cleaning up before extraction")
            _ = try? call("rm -rf '/Applications/Install macOS Big Sur.app'", p: password)
            _ = try? call("rm -rf '/Applications/Install macOS Big Sur Beta.app'", p: password)
            _ = try? call("rm -rf /Applications/PSInstaller.app", p: password)
            print("Extracting Package at \(installInfo.url)")
            try call("installer -pkg '\(installInfo.url)' -target /", p: password)
            print("Done extracting package.")
        } else {
            if installInfo.url != "/Applications/Install macOS Big Sur.app" {
                print("Cleaning up before move.")
                _ = try? call("rm -rf '/Applications/Install macOS Big Sur.app'", p: password)
                print("Moving installer app")
                try call("mv '\(installInfo.url)' '/Applications/Install macOS Big Sur.app'")
                print("Done moving this app for this dumb workaround that I have to use for dumb reasons.")
            }
        }
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
        print("Starting createinstallmedia")
        progressText("Starting createinstallmedia")
        try call("/Applications/Install\\ macOS\\ Big\\ Sur*/Contents/Resources/createinstallmedia --volume '/Volumes/\(volume)' --nointeraction", p: password, h: progressText)
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
        progressText("Starting USB Patch")
        print("Killing MDS again...")
        _ = try? call("killall mds", p: password)
        _ = try? call("killall mds_stores", p: password)
        print("Starting to patch USB installer")
        try call("/Volumes/Patched-Sur/.patch-usb.sh", p: password, h: progressText)
        progressText("Copying Post-Install App")
        print("Copying Post-Install App")
        _ = try? call("rm -rf '/Applications/Patched Sur.app'")
        try call("cp -rf '/Volumes/Patched-Sur/.fullApp.app' '/Applications/Patched Sur.app'")
        print("Successfully patched USB.")
        errorX("DONE")
    } catch {
        _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
        _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
        print("Failed to create installer media.")
        errorX(error.localizedDescription)
    }
}
