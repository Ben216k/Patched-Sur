//
//  DownloadActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/16/21.
//

import Foundation
import Files

// MARK: Download Kexts

func kextDownload(size: (Int) -> (), next: () -> (), errorX: (String) -> ()) {
    do {
        print("Clean up before patches download")
        _ = try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
        _ = try? Folder(path: "~/.patched-sur/big-sur-micropatcher").delete()
        _ = try? call("rm -rf ~/.patched-sur/big-sur-micropatcher*")
        _ = try? File(path: "~/.patched-sur/big-sur-micropatcher.zip").delete()
        print("Getting projected size")
        if let sizeString = try? shellOut(to: "curl -sI https://codeload.github.com/BenSova/big-sur-micropatcher/zip/main | grep -i Content-Length | awk '{print $2}'"), let sizeInt = Int(sizeString) {
            size(sizeInt)
        }
        print("Starting download of patches")
        try call("curl -o ~/.patched-sur/big-sur-micropatcher.zip https://codeload.github.com/BenSova/big-sur-micropatcher/zip/main")
        print("Extracting patches")
        try call("unzip big-sur-micropatcher.zip", at: "~/.patched-sur")
        print("Cleaning up after patches download")
        _ = try? File(path: "~/.patched-sur/big-sur-micropatcher*").delete()
        try call("mv ~/.patched-sur/big-sur-micropatcher-main ~/.patched-sur/big-sur-micropatcher")
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
        let sizeStrings = sizeString.split(separator: "\n")
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
            try call("curl -L -o InstallAssistant.pkg \(installInfo!.url)", at: "~/.patched-sur")
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
