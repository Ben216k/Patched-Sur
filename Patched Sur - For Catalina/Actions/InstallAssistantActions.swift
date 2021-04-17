//
//  InstallAssistantActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 3/14/21.
//

import VeliaUI

// MARK: Fetch Installers

func fetchInstallers(errorX: (String) -> (), track: ReleaseTrack) -> InstallAssistants {
    do {
        print("Fetching installers from 'https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : "Release").json'")
        var installers = try InstallAssistants(fromURL: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : "Release").json")
        print("Fetched: \(installers.map { $0.version })")
        print("Filtering installer list for compatible versions")
        installers = installers.filter { $0.minVersion <= AppInfo.build }
        print("Sorting installer list")
        installers.reverse()
        print("Verifying there are compatible installers")
        if installers.count > 0 {
            print("Passing back installers")
            return installers
        } else {
            print("Installer list has no values, this patcher version must have been discontinued.")
            errorX("This version of Patched Sur has been discontinued.\nPlease use the latest version of the patcher.")
            return []
        }
    } catch {
        print("InstallAssistant fetch failed.")
        errorX(error.localizedDescription)
        return []
    }
}

// MARK: Verify Installer

func verifyInstaller(alert: inout Alert?, path: String) -> Bool {
    print("Verifying pre-downloaded installer at path \(path)")
    if path.suffix(3) == "app" {
        do {
            print("Checking for installer GUI binary")
            try call("[[ -e '\(path)/Contents/MacOS/InstallAssistant' ]]")
            print("Checking for createinstall media binary")
            try call("[[ -e '\(path)/Contents/Resources/createinstallmedia' ]]")
            print("Checking for SharedSupport image")
            try call("[[ -e '\(path)/Contents/SharedSupport/SharedSupport.dmg' ]]")
            print("Checking for OSInstallerSetup framework")
            try call("[[ -d '\(path)/Contents/Frameworks/OSInstallerSetup.framework' ]]")
            print("Successfully verified installer.")
            return true
        } catch {
            print("Check failed. This is an invalid installer")
            alert = .init(title: Text("Failed to verify macOS installer app."), message: Text("Make sure the installer has all the required resources, like the SharedSupport.dmg and required frameworks, and is not an official macOS installer downloaded from Apple."))
        }
    } else {
        print("Checking installer size")
        if let sizeCode = try? call("stat -f %z '\(path)'") {
            print("Phrasing and verifying installer size")
            if Int(Float(sizeCode) ?? 10000) >= 12100000000 {
                print("Successfully verified installer.")
                return true
            }
        }
        print("Size check fell through. This is an invalid installer.")
        alert = .init(title: Text("Failed to verify macOS installer package."), message: Text("Make sure the installer is not corrupted and contains the full installer."))
    }
    return false
}
