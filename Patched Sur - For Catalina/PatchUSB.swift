//
//  PatchUSB.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 10/30/20.
//

import Foundation
import Files

func patchUSB(_ password: String) throws {
    
    // MARK: Initialize locations
    
    // Installer USB Drive/Folder to patch
    guard let installerUSBDir = try? Folder(path: "/Volumes/Install macOS Big Sur Beta") else {
        throw BasicError("Unable to locate Big Sur installer drive.\nMake sure drive name did not change since createinstallmedia.")
    }
    
    let installerUSB = installerUSBDir.path
    
    guard let installerAppDir = try? Folder(path: "/Volumes/Install macOS Big Sur Beta/Install macOS Big Sur Beta.app") else {
        throw BasicError("Unable to locate Big Sur installer app.\nMake sure drive or app name did not change since createinstallmedia.")
    }
    
    let installerApp = installerAppDir.path
    
    var micropatcherV = AppInfo.micropatcher
    micropatcherV.removeFirst()
    
    // Micropatcher Folder for Resources
    guard let micropatcherDir = try? Folder(path: "~/.patched-sur/big-sur-micropatcher-\(micropatcherV)") else {
        throw BasicError("Unable to locate micropatcher folder.\nMake sure that nothing moved or removed the micropatcher folder.")
    }
    
    let micropatcher = micropatcherDir.path
    
    // MARK: Patch USB
    
    // Backup com.apple.Boot.plist
    do {
        try shellOut(to: "echo \"\(password)\" | sudo -S cp \"\(installerUSB)/Library/Preferences/SystemConfiguration/com.apple.Boot.plist\" \"\(installerUSB)/Library/Preferences/SystemConfiguration/com.apple.Boot.plist.stock\"")
    } catch let error as ShellOutError {
        throw BasicError("Could not backup com.apple.Boot.plist. \(error)")
    } catch {
        throw BasicError("Could not backup com.apple.Boot.plist for an unknown reason.")
    }
    
    // Replace com.apple.Boot.plist
    do {
        try shellOut(to: "echo \"\(password)\" | sudo -S cat \(micropatcher)/payloads/com.apple.Boot.plist > \"\(installerUSB)/Library/Preferences/SystemConfiguration/com.apple.Boot.plist\"")
    } catch let error as ShellOutError {
        throw BasicError("Could not replace com.apple.Boot.plist. \(error)")
    } catch {
        throw BasicError("Could not replace com.apple.Boot.plist for an unknown reason.")
    }
    
    // Set up trampoline app
    
    do {
        try shellOut(to: "/bin/mv -f \"\(installerApp)\" \"\(installerUSB)trampoline.app\"")
        try shellOut(to: "/bin/cp -r \"\(micropatcher)/payloads/trampoline.app\" \"\(installerApp)\"")
        try shellOut(to: "/bin/mv -f \"\(installerUSB)/trampoline.app\" \"\(installerApp)/Contents/MacOS/InstallAssistant.app\"")
        try shellOut(to: "/bin/cp \"\(installerApp)/Contents/MacOS/InstallAssistant\" \"\(installerApp)/Contents/MacOS/InstallAssistant_plain\"")
        try shellOut(to: "/bin/cp \"\(installerApp)/Contents/MacOS/InstallAssistant\" \"\(installerApp)/Contents/MacOS/InstallAssistant_springboard\"")
        try installerAppDir.subfolder(at: "Contents/MacOS/InstallAssistant.app/Contents").files.forEach({ (file) in
            try shellOut(to: "/bin/ln -s \"\(file.path)\" \"\(installerApp)/Contents/\(file.name)\" ")
        })
        try installerAppDir.subfolder(at: "Contents/MacOS/InstallAssistant.app/Contents").subfolders.forEach({ (folder) in
            try shellOut(to: "/bin/ln -s \"\(folder.path)\" \"\(installerApp)/Contents/\(folder.name)\" ")
        })
        try shellOut(to: "touch \"\(installerApp)\"")
    } catch let error as ShellOutError {
        throw BasicError("Could not setup trampoline app. \(error)")
    } catch {
        throw BasicError("Could not setup trampoline app for an unknown reason.")
    }
    
    // MARK: Move Resources
    
    // Copy Scripts
    
    do {
        try shellOut(to: "/bin/cp -f \"\(micropatcher)/payloads/patch-kexts.sh\" \"\(micropatcher)/payloads/kmutil.beta8re\" \"\(micropatcher)/payloads/bless.beta9re\" \"\(installerUSB)\"")
        try shellOut(to: "/bin/cp -f \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib\" \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSealNoAPFSROMCheck.dylib\" \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxSeal.dylib\" \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxSealNoAPFSROMCheck.dylib\" \"\(installerUSB)\"")
        try shellOut(to: "/bin/cp -f \"\(micropatcher)/payloads/unpatch-kexts.sh\" \"\(micropatcher)/payloads/insert-hax.sh\" \"\(installerUSB)\"")
    } catch let error as ShellOutError {
        throw BasicError("Could not copy scripts. \(error)")
    } catch {
        throw BasicError("Could not copy scripts for an unknown reason.")
    }
    
    // Manage Permissions for Scripts
    
    do {
        try shellOut(to: "chmod u+x \"\(installerUSB)/patch-kexts.sh\" && chmod u+x \"\(installerUSB)/kmutil.beta8re\" \"\(installerUSB)/bless.beta9re\"")
        try shellOut(to: "chmod u+x \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSeal.dylib\" \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxDoNotSealNoAPFSROMCheck.dylib\" \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxSeal.dylib\" \"\(micropatcher)/payloads/ASentientBot-Hax/BarryKN-fork/HaxSealNoAPFSROMCheck.dylib\"")
        try shellOut(to: "chmod u+x \"\(installerUSB)/unpatch-kexts.sh\"")
    } catch let error as ShellOutError {
        throw BasicError("Could not fix permissions for scripts. \(error)")
    } catch {
        throw BasicError("Could not fix permissions for scripts for an unknown reason.")
    }
    
    // Move Kexts
    
    do {
        try shellOut(to: "cp -rf \"\(micropatcher)/payloads/kexts\" \"\(installerUSB)\"")
    } catch let error as ShellOutError {
        throw BasicError("Could not move Kexts. \(error)")
    } catch {
        throw BasicError("Could not move kexts for an unknown reason.")
    }
    
    // Move Version for Reference
    
    do {
        try shellOut(to: "echo \"\(AppInfo.micropatcher)\" > \"\(installerUSB)/Patch-Version.txt\"")
    } catch {
        print("Failed to move micropatcher version for some reason.")
    }
    
    // Sync!
    
    do {
        try shellOut(to: "sync")
    } catch {
        print("Failed to sync for some reason.")
    }
}

struct BasicError: Error, CustomStringConvertible, LocalizedError {
    var description: String
    var errorDescription: String? {
        description
    }
    init(_ d: String) {
        description = d
    }
}
