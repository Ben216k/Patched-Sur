//
//  InstallerActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/20/21.
//

import Foundation

func extractPackage(package: String, password: String, errorX: (String) -> ()) {
    do {
        print("Cleaning up before extraction")
        _ = try? call("rm -rf '/Applications/Install macOS Big Sur.app'")
        _ = try? call("rm -rf '/Applications/Install macOS Big Sur Beta.app'")
        _ = try? call("rm -rf /Applications/PSInstaller.app")
        print("Extracting Package at \(package)")
        try call("installer -pkg '\(package)' -target /", p: password)
        print("Moving installer to Patched Sur location")
        _ = try? call("mv '/Applications/Install macOS Big Sur.app' /Applications/PSInstaller.app", p: password)
        _ = try? call("mv '/Applications/Install macOS Big Sur Beta.app' /Applications/PSInstaller.app", p: password)
        print("Done extracting package.")
        errorX("CREATE")
    } catch {
        print("Failed to extract package.")
        errorX(error.localizedDescription)
    }
}

func createInstallMedia(volume: String, installer: String, password: String, progressText: @escaping (String) -> (), errorX: (String) -> ()) {
    do {
        progressText("Temporarily disabling Spotlight indexng")
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
        try call("'\(installer)/Contents/Resources/createinstallmedia' --volume '/Volumes/\(volume)' --nointeraction", p: password, h: progressText)
        print("Finished createinstallmedia!")
        errorX("PATCH")
    } catch {
        _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
        _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
        print("Failed to create installer media.")
        errorX(error.localizedDescription)
    }
}

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
        errorX = "DONE"
    } catch {
        _ = try? call("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist", p: password)
        _ = try? call("sudo launchctl enable system/com.apple.displaypolicyd", p: password)
        print("Failed to create installer media.")
        errorX(error.localizedDescription)
    }
}
