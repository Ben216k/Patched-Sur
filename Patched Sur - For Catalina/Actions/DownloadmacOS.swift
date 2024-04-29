//
//  DownloadmacOS.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import Foundation
import Files
import IOKit
import IOKit.pwr_mgt
import OSLog

func macOSDownload(installInfo: InstallAssistant?, size: (Int) -> (), next: () -> (), errorX: (String) -> ()) {
    OSLog.downloads.log("Cleaning up before macOS download")
    _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
    _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
    OSLog.downloads.log("Getting projected InstallAssistant size")
    if let sizeString = try? call("curl -sI \(installInfo!.url) | grep -i Content-Length | awk '{print $2}'") {
        let sizeStrings = sizeString.split(separator: "\r\n")
        print(sizeStrings)
        if sizeStrings.count > 0, let sizeInt = Int(sizeStrings[0]) {
            size(sizeInt)
        }
    }
    do {
        OSLog.downloads.log("Preventing sleep.")
        let reasonForActivity = "Reason for activity" as CFString
        var assertionID: IOPMAssertionID = 0
        var success = IOPMAssertionCreateWithName( kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                    IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                    reasonForActivity,
                                                    &assertionID )
        OSLog.downloads.log("Starting download of macOS")
        print("\(installInfo!.version)")
        if success == kIOReturnSuccess {
            try call("curl -L -o InstallAssistant.pkg \(installInfo!.url) --speed-limit 0 --speed-time 10", at: "~/.patched-sur")
            OSLog.downloads.log("Finished download.")
            OSLog.downloads.log("Releasing sleep.")
            success = IOPMAssertionRelease(assertionID)
        } else {
            OSLog.downloads.log("Sleep prevention failed.")
            try call("curl -L -o InstallAssistant.pkg \(installInfo!.url)", at: "~/.patched-sur")
            OSLog.downloads.log("Finished download.")
        }
        OSLog.downloads.log("Saving InstallAssistant.pkg information in case we need it again.")
        let versionFile = try Folder(path: "~/.patched-sur").createFileIfNeeded(at: "InstallInfo.txt")
        do {
            try versionFile.write(try JSONEncoder().encode(installInfo))
        } catch {
            OSLog.downloads.log("Unable to save install info to file. Boohoo.", type: .error)
        }
        OSLog.downloads.log("Continuing.")
        next()
    } catch {
        errorX(error.localizedDescription)
    }
}
