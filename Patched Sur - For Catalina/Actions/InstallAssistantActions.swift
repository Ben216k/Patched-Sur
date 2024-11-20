//
//  InstallAssistantActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import Foundation
import OSLog
import SwiftUI

// MARK: - Fetch Installers

func fetchInstallers(errorX: (String) -> ()) -> [InstallAssistant] {
    do {
        OSLog.downloads.log("Fetching installers from 'https://ben216k.github.io/patched-sur/Release.json'")
//        var installers = try [InstallAssistant](fromURL: "https://ben216k.github.io/patched-sur/Release.json")
        var installers = try JSONDecoder().decode([InstallAssistant].self, from: .init(contentsOf: URL(string: "https://ben216k.github.io/patched-sur/Release.json")!))
        print("Fetched: \(installers.map { $0.version })")
        OSLog.downloads.log("Filtering installer list for compatible versions")
        installers = installers.filter { $0.minVersion <= AppInfo.build }
        OSLog.downloads.log("Sorting installer list")
        installers.reverse()
        OSLog.downloads.log("Verifying there are compatible installers")
        if installers.count > 0 {
            OSLog.downloads.log("Passing back installers")
            return installers
        } else {
            OSLog.downloads.log("Installer list has no values, this patcher version must have been discontinued.", type: .fault)
            errorX("This version of Patched Sur has been discontinued.\nPlease use the latest version of the patcher.")
            return []
        }
    } catch {
        OSLog.downloads.log("InstallAssistant fetch failed.", type: .fault)
        errorX(error.localizedDescription)
        return []
    }
}

// MARK: - Verify Installer

func verifyInstaller(alert: inout Alert?, path: String) -> Bool {
    print("Verifying pre-downloaded installer at path \(path)")
    if path.suffix(3) == "app" {
        do {
            OSLog.verification.log("Checking for installer GUI binary")
            try call("[[ -e '\(path)/Contents/MacOS/InstallAssistant' ]]")
            OSLog.verification.log("Checking for createinstall media binary")
            try call("[[ -e '\(path)/Contents/Resources/createinstallmedia' ]]")
            OSLog.verification.log("Checking for SharedSupport image")
            try call("[[ -e '\(path)/Contents/SharedSupport/SharedSupport.dmg' ]]")
            OSLog.verification.log("Checking for OSInstallerSetup framework")
            try call("[[ -d '\(path)/Contents/Frameworks/OSInstallerSetup.framework' ]]")
            OSLog.verification.log("Successfully verified installer.")
            return true
        } catch {
            OSLog.verification.log("Check failed. This is an invalid installer", type: .error)
            alert = .init(title: Text("Failed to verify macOS installer app."), message: Text("Make sure the installer has all the required resources, like the SharedSupport.dmg and required frameworks, and is not an official macOS installer downloaded from Apple."))
        }
    } else if path.suffix(3) == "pkg" {
        OSLog.verification.log("Checking installer size")
        if let sizeCode = try? call("stat -f %z '\(path)'") {
            print("Phrasing and verifying installer size")
            if Int(Float(sizeCode) ?? 10000) >= 12100000000 {
                print("Successfully verified installer.")
                return true
            }
        }
        OSLog.verification.log("Size check fell through. This is an invalid installer.", type: .error)
        alert = .init(title: Text("Failed to verify macOS installer package."), message: Text("Make sure the installer is not corrupted and contains the full installer."))
    } else {
        OSLog.verification.log("Selected installer extension is not vaid.", type: .error)
    }
    return false
}
