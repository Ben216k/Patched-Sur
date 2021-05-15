//
//  UpdaterActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/9/21.
//

import Foundation
import SwiftUI
import Files

// MARK: Check General Update Compat

func checkGeneralUpdateCompat(worked: (Bool) -> ()) {
    print("Checking for Library Validation...")
    var libraryValidation = ""
    do {
        libraryValidation = try call("defaults read /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation")
    } catch {
        libraryValidation = "jfhsdkljfhklasdhfkjldhskjf"
//        print("Failed to check library validation status.")
//        presentAlert(m: "Failed to check Library Validation Status", i: "Patched Sur failed to check your SIP status, which should be impossible.\n\n\(error.localizedDescription)", s: .critical)
    }
    print("Checking for SIP...")
    var csrstatus = ""
    do {
        csrstatus = try call("csrutil status")
    } catch {
        print("Failed to check csr status.")
        presentAlert(m: NSLocalizedString("PO-UP-COMPAT-FAIL-SIP", comment: "PO-UP-COMPAT-FAIL-SIP"), i: "\(NSLocalizedString("PO-UP-COMPAT-FAIL-SIP-2", comment: "PO-UP-COMPAT-FAIL-SIP-2"))\n\n\(error.localizedDescription)", s: .critical)
    }
    if csrstatus.contains("status: enabled") || csrstatus.contains("Debugging Restrictions: enabled") {
        print("CSR is Enabled! The updater cannot be run.")
        presentAlert(m: NSLocalizedString("PO-UP-COMPAT-SIP-ON", comment: "PO-UP-COMPAT-SIP-ON"), i: NSLocalizedString("PO-UP-COMPAT-SIP-ON-2", comment: "PO-UP-COMPAT-SIP-ON-2"))
    } else if !libraryValidation.contains("1") {
        print("Library Validation is not set, warning user.")
        let al = NSAlert()
        al.informativeText = NSLocalizedString("PO-UP-COMPAT-LV-ON-2", comment: "PO-UP-COMPAT-LV-ON-2")
        al.messageText = NSLocalizedString("PO-UP-COMPAT-LV-ON", comment: "PO-UP-COMPAT-LV-ON")
        al.showsHelp = false
        al.addButton(withTitle: "Continue")
        al.addButton(withTitle: "Cancel")
        switch al.runModal() {
        case .alertFirstButtonReturn:
            worked(false)
        default:
            break
        }
    } else {
        print("Library Validation is off, continuing...")
        worked(true)
    }
}

// MARK: Download Kexts / macOS

func upDownloadKexts(useCurrent: Bool, installInfo: InstallAssistant, downloadSize: (Int) -> (), kextDownloaded: () -> (), errorX: (String) -> (), done: () -> ()) {
    if !AppInfo.nothing {
        do {
            print("Cleaning up before download...")
            if !(installInfo.buildNumber.contains("Custom")) {
                _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
                _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
            }
            _ = try Folder.home.createSubfolderIfNeeded(at: ".patched-sur")
            _ = try? Folder(path: "~/.patched-sur/Patched-Sur-Patches").delete()
            _ = try? call("rm -rf ~/.patched-sur/Patched-Sur-Patches*")
            _ = try? File(path: "~/.patched-sur/Patched-Sur-Patches.zip").delete()
            _ = try? call("rm -rf ~/.patched-sur/__MACOSX")
            print("Starting download of patches...")
            try call("curl -Lo ~/.patched-sur/Patched-Sur-Patches.zip \(AppInfo.patchesV.url) --speed-limit 0 --speed-time 10")
            print("Finished downloading the patches!")
            kextDownloaded()
            if !(installInfo.buildNumber.contains("Custom")) {
                if let sizeString = try? call("curl -sI \(installInfo.url) | grep -i Content-Length | awk '{print $2}'") {
                    let sizeStrings = sizeString.split(separator: "\r\n")
                    print(sizeStrings)
                    if sizeStrings.count > 0, let sizeInt = Int(sizeStrings[0]) {
                        downloadSize(sizeInt)
                    }
                }
                let reasonForActivity = "Reason for activity" as CFString
                var assertionID: IOPMAssertionID = 0
                var success = IOPMAssertionCreateWithName( kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                            IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                            reasonForActivity,
                                                            &assertionID )
                if success == kIOReturnSuccess {
                    try call("curl -Lo ~/.patched-sur/InstallAssistant.pkg \(installInfo.url) --speed-limit 0 --speed-time 10")
                    success = IOPMAssertionRelease(assertionID)
                } else {
                    try call("curl -Lo ~/.patched-sur/InstallAssistant.pkg \(installInfo.url) --speed-limit 0 --speed-time 10")
                }
                print("Updating InstallInfo.txt")
                if let versionFile = try? Folder(path: "~/.patched-sur").createFileIfNeeded(at: "InstallInfo.txt") {
                    _ = try? versionFile.write(installInfo.jsonString()!, encoding: .utf8)
                }
            }
            done()
        } catch {
            AppInfo.canReleaseAttention = true
            errorX(error.localizedDescription)
        }
    } else {
        print("Download lol.")
        sleep(5)
        done()
    }
}

// MARK: Start Install

func startOSInstall(password: String, installInfo: InstallAssistant, currentText: @escaping (String) -> (), errorX: (String) -> ()) {
    if !AppInfo.nothing {
        do {
            let handle: (String) -> () = {
                currentText($0 != "Password:" ? $0 : "Starting OS Installer")
            }
            scheduleNotification(title: "macOS Update Starting Soon", body: "macOS and the kexts finished downloading, and the updater is getting ready to start. Make sure to save your work, since it could start anytime soon.")
            currentText("Extracting Patches")
            print("Being safe before we delete stuff...")
            _ = try? call("launchctl unsetenv DYLD_INSERT_LIBRARIES")
            _ = try? call("sudo launchctl unsetenv DYLD_INSERT_LIBRARIES", p: password)
            print("Cleaning up before extraction...")
            _ = try? call("mkdir /usr/local/lib", p: password)
            _ = try? call("rm -rf ~/.patched-sur/__MACOSX", p: password)
            _ = try? call("rm -rf /usr/local/lib/__MACOSX", p: password)
            _ = try? call("rm -rf Patched-Sur-Patches*", p: password, at: "/usr/local/lib")
            print("Extracting patches")
            try call("unzip ~/.patched-sur/Patched-Sur-Patches.zip -d /usr/local/lib", p: password, at: "/usr/local/lib")
            print("Post-extract clean up")
            try call("mv Patched-Sur-Patches-* Patched-Sur-Patches", p: password, at: "/usr/local/lib")
            _ = try? call("rm -rf ~/.patched-sur/__MACOSX", p: password)
            _ = try? call("rm -rf /usr/local/lib/__MACOSX", p: password)
            _ = try? call("echo '\(AppInfo.patchesV.version)' > /usr/local/lib/Patched-Sur-Patches/pspVersion", p: password)
            currentText("Starting Installer Patches")
            print("Confirming Hax permissions...")
            try call("chmod u+x /usr/local/lib/Patched-Sur-Patches/InstallerHax/Hax6/Hax6.dylib", p: password)
            print("Injecting Hax...")
            try call("launchctl setenv DYLD_INSERT_LIBRARIES /usr/local/lib/Patched-Sur-Patches/InstallerHax/Hax6/Hax6.dylib")
            try call("sudo launchctl setenv DYLD_INSERT_LIBRARIES /usr/local/lib/Patched-Sur-Patches/InstallerHax/Hax6/Hax6.dylib", p: password)
            sleep(2)
            print("Configuration: \(installInfo.url) and \(installInfo.buildNumber)")
            if !(installInfo.buildNumber.contains("APP")) {
                currentText("Cleaning up before extraction")
                print("Clean up before extraction...")
                if (try? call("[[ -d /Applications/Install\\ macOS\\ Big\\ Sur.app ]]")) != nil || (try? call("[[ -d /Applications/Install\\ macOS\\ Big\\ Sur\\ Beta.app ]]")) != nil {
                    if (try? call("mkdir /Applications/Backup-Installers", p: password)) != nil {
                        _ = try? call("echo 'This folder was created by Patched Sur to protect your existing macOS installers while the patcher runs.' > /Applications/Backup-Installers/README.txt")
                        _ = try? call("mv /Applications/Install\\ macOS\\ Big\\ Sur*.app /Applications/Backup-Installers/", p: password)
                    }
                }
                _ = try? call("rm -rf ~/.patched-sur/pkg-extract", p: password)
                currentText("Unpacking package")
                print("Unpacking package...")
                try call("installer -pkg \(installInfo.url) -target /", p: password)
                currentText("Starting OS Installer")
                print("Starting OS Installer....")
                try call("/Applications/Install\\ macOS\\ Big\\ Sur*.app/Contents/Resources/startosinstall --volume / --nointeraction", p: password, h: handle)
    //            try call("/Applications/Install\\ macOS\\ Big\\ Sur*.app/Contents/Resources/createinstallmedia", p: password, h: handle)
    //            try call("[[ -e /Applications/Install\\ macOS\\ Big\\ Sur*/Contents/Resources/startosinstall ]]")
            } else {
                currentText("Starting OS Installer")
                print("Starting OS Installer...")
                try call("'\(installInfo.url)/Contents/Resources/startosinstall' --volume / --agreetolicense", p: password, h: handle)
    //            try call("'\(installInfo.url)/Contents/Resources/createinstallmedia'", p: password, h: handle)
            }
        } catch {
            AppInfo.canReleaseAttention = true
            errorX(error.localizedDescription)
        }
    } else {
        print("No start.")
        sleep(2)
        print("Yeah.... just restart the patcher...")
    }
}
