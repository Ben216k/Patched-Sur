//
//  DownloadActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/16/21.
//

import Foundation
import Files
import IOKit
import IOKit.pwr_mgt

// MARK: Download Kexts

func kextDownload(size: (Int) -> (), next: () -> (), errorX: (String) -> ()) {
    do {
        print("Clean up before patches download")
        _ = try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
        _ = try? Folder(path: "~/.patched-sur/Patched-Sur-Patches").delete()
        _ = try? call("rm -rf ~/.patched-sur/Patched-Sur-Patches*")
        _ = try? File(path: "~/.patched-sur/Patched-Sur-Patches.zip").delete()
        print("Getting projected size")
        print(AppInfo.patchesV.url)
        if let sizeString = try? call("curl -sI \(AppInfo.patchesV.url) | grep -i Content-Length | awk '{print $2}'") {
            let sizeStrings = sizeString.split(separator: "\r\n")
            print(sizeStrings)
            if sizeStrings.count > 0, let sizeInt = Int(sizeStrings[0]) {
                size(sizeInt)
            }
        }
        print("Starting download of patches")
        try call("curl -Lo ~/.patched-sur/Patched-Sur-Patches.zip \(AppInfo.patchesV.url) --speed-limit 0 --speed-time 10")
        print("Finished download.")
        next()
    } catch {
        errorX(error.localizedDescription)
    }
}

// MARK: Download macOS

func macOSDownload(installInfo: InstallAssistant?, size: (Int) -> (), next: () -> (), errorX: (String) -> ()) {
    print("Cleaning up before macOS download")
    _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
    _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
    print("Getting projected InstallAssistant size")
    if let sizeString = try? call("curl -sI \(installInfo!.url) | grep -i Content-Length | awk '{print $2}'") {
        let sizeStrings = sizeString.split(separator: "\r\n")
        print(sizeStrings)
        if sizeStrings.count > 0, let sizeInt = Int(sizeStrings[0]) {
            size(sizeInt)
        }
    }
    do {
        print("Preventing sleep.")
        let reasonForActivity = "Reason for activity" as CFString
        var assertionID: IOPMAssertionID = 0
        var success = IOPMAssertionCreateWithName( kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                    IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                    reasonForActivity,
                                                    &assertionID )
        print("Starting download of macOS \(installInfo!.version)")
        if success == kIOReturnSuccess {
            try call("curl -L -o InstallAssistant.pkg \(installInfo!.url) --speed-limit 0 --speed-time 10", at: "~/.patched-sur")
            print("Finished download.")
            print("Releasing sleep.")
            success = IOPMAssertionRelease(assertionID)
        } else {
            print("Sleep prevention failed.")
            try call("curl -L -o InstallAssistant.pkg \(installInfo!.url)", at: "~/.patched-sur")
            print("Finished download.")
        }
        print("Saving InstallAssistant.pkg information in case we need it again.")
        let versionFile = try Folder(path: "~/.patched-sur").createFileIfNeeded(at: "InstallInfo.txt")
        try versionFile.write(installInfo!.jsonString()!, encoding: .utf8)
        print("Continuing.")
        next()
    } catch {
        errorX(error.localizedDescription)
    }
}
