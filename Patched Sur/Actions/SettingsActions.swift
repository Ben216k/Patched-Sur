//
//  SettingsActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 3/10/21.
//

import Foundation
import AppKit

// MARK: Manage Animations

func disableAnimations() {
    if !AppInfo.nothing {
        print("Disabling animations...")
        _ = try? call("defaults write -g NSAutomaticWindowAnimationsEnabled -bool false")
        _ = try? call("defaults write -g NSScrollAnimationEnabled -bool false")
        _ = try? call("defaults write -g NSWindowResizeTime -float 0.001")
        _ = try? call("defaults write -g QLPanelAnimationDuration -float 0")
        _ = try? call("defaults write -g NSScrollViewRubberbanding -bool false")
        _ = try? call("defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false")
        _ = try? call("defaults write -g NSToolbarFullScreenAnimationDuration -float 0")
        _ = try? call("defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0")
        _ = try? call("defaults write com.apple.dock autohide-time-modifier -float 0")
        _ = try? call("defaults write com.apple.dock autohide-delay -float 0")
        _ = try? call("defaults write com.apple.dock expose-animation-duration -float 0")
        _ = try? call("defaults write com.apple.dock springboard-show-duration -float 0")
        _ = try? call("defaults write com.apple.dock springboard-hide-duration -float 0")
        _ = try? call("defaults write com.apple.dock springboard-page-duration -float 0")
        _ = try? call("defaults write com.apple.finder DisableAllAnimations -bool true")
        _ = try? call("defaults write com.apple.Mail DisableSendAnimations -bool true")
        _ = try? call("defaults write com.apple.Mail DisableReplyAnimations -bool true")
        _ = try? call("defaults write NSGlobalDomain NSWindowResizeTime .001")
    } else {
        print("Lol no.")
    }
}

func enableAnimations() {
    if !AppInfo.nothing {
        print("Enabling animations...")
        _ = try? call("defaults delete -g NSAutomaticWindowAnimationsEnabled")
        _ = try? call("defaults delete -g NSScrollAnimationEnabled")
        _ = try? call("defaults delete -g NSWindowResizeTime")
        _ = try? call("defaults delete -g QLPanelAnimationDuration")
        _ = try? call("defaults delete -g NSScrollViewRubberbanding")
        _ = try? call("defaults delete -g NSDocumentRevisionsWindowTransformAnimation")
        _ = try? call("defaults delete -g NSToolbarFullScreenAnimationDuration")
        _ = try? call("defaults delete -g NSBrowserColumnAnimationSpeedMultiplier")
        _ = try? call("defaults delete com.apple.dock autohide-time-modifier")
        _ = try? call("defaults delete com.apple.dock autohide-delay")
        _ = try? call("defaults delete com.apple.dock expose-animation-duration")
        _ = try? call("defaults delete com.apple.dock springboard-show-duration")
        _ = try? call("defaults delete com.apple.dock springboard-hide-duration")
        _ = try? call("defaults delete com.apple.dock springboard-page-duration")
        _ = try? call("defaults delete com.apple.finder DisableAllAnimations")
        _ = try? call("defaults delete com.apple.Mail DisableSendAnimations")
        _ = try? call("defaults delete com.apple.Mail DisableReplyAnimations")
        _ = try? call("defaults delete NSGlobalDomain NSWindowResizeTime")
    } else {
        print("Haha, no.")
    }
}

// MARK: Manage Graphics Switching

func enableGxSwitching(p password: String) {
    if !AppInfo.nothing {
        do {
            print("Stopping displaypolicyd...")
            _ = try? call("launchctl stop system/com.apple.displaypolicyd", p: password)
            print("Enabling Automatic Graphics Switching...")
            try call("launchctl disable system/com.apple.displaypolicyd", p: password)
            presentAlert(m: NSLocalizedString("PO-ST-GXS-ENABLE-DONE", comment: "PO-ST-GXS-ENABLE-DONE"), i: NSLocalizedString("PO-ST-GXS-ENABLE-DONE-2", comment: "PO-ST-GXS-ENABLE-DONE-2"), s: .informational)
        } catch {
            presentAlert(m: NSLocalizedString("PO-ST-GXS-ENABLE-FAILED", comment: "PO-ST-GXS-ENABLE-FAILED"), i: error.localizedDescription, s: .critical)
        }
    } else {
        print("I WILL NOT DO WORK")
        if Int.random(in: 1..<3) == 1 {
            print("Pretend A")
            presentAlert(m: NSLocalizedString("PO-ST-GXS-ENABLE-DONE", comment: "PO-ST-GXS-ENABLE-DONE"), i: NSLocalizedString("PO-ST-GXS-ENABLE-DONE-2", comment: "PO-ST-GXS-ENABLE-DONE-2"), s: .informational)
        } else {
            print("Pretend B")
            presentAlert(m: NSLocalizedString("PO-ST-GXS-ENABLE-FAILED", comment: "PO-ST-GXS-ENABLE-FAILED"), i: "ERROR TEXT GOES HERE. Don't worry about the fact this isn't localized or anything. I'm too lazy to type something else because I'm in lazy mode.", s: .critical)
        }
    }
}

func disableGxSwitching(p password: String) {
    if !AppInfo.nothing {
        do {
            print("Disabling Automatic Graphics Switching...")
            try call("launchctl enable system/com.apple.displaypolicyd", p: password)
            print("Starting displaypolicyd...")
            _ = try? call("launchctl kickstart system/com.apple.displaypolicyd", p: password)
            presentAlert(m: NSLocalizedString("PO-ST-GXS-DISABLE-DONE", comment: "PO-ST-GXS-DISABLE-DONE"), i: NSLocalizedString("PO-ST-GXS-DISABLE-DONE-2", comment: "PO-ST-GXS-DISABLE-DONE-2"), s: .informational)
        } catch {
            presentAlert(m: NSLocalizedString("PO-ST-GXS-DISABLE-FAILED", comment: "PO-ST-GXS-DISABLE-FAILED"), i: error.localizedDescription, s: .critical)
        }
    } else {
        print("I WILL NOT UNDO WORK")
        if Int.random(in: 1..<3) == 1 {
            presentAlert(m: NSLocalizedString("PO-ST-GXS-DISABLE-DONE", comment: "PO-ST-GXS-DISABLE-DONE"), i: NSLocalizedString("PO-ST-GXS-DISABLE-DONE-2", comment: "PO-ST-GXS-DISABLE-DONE-2"), s: .informational)
        } else {
            presentAlert(m: NSLocalizedString("PO-ST-GXS-DISABLE-FAILED", comment: "PO-ST-GXS-DISABLE-FAILED"), i: "ERROR TEXT GOES HERE. Don't worry about the fact this isn't localized or anything. I'm too lazy to type something else because I'm in lazy mode.", s: .critical)
        }
    }
}

// MARK: Clean Leftovers

func cleanLeftovers() {
    if !AppInfo.nothing {
        _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
        _ = try? call("rm -rf ~/.patched-sur/Install\\ macOS Big\\ Sur*.app")
        _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
        _ = try? call("rm -rf ~/.patched-sur/trash")
    }
    print("Lol, no u. Take that extra space.")
    presentAlert(m: NSLocalizedString("PO-ST-CL-DONE", comment: "PO-ST-CL-DONE"), i: NSLocalizedString("PO-ST-CL-DONE-2", comment: "PO-ST-CL-DONE-2"), s: .informational)
}


// MARK: Relaunch Patcher

func relaunchPatcher() {
    let appURL = URL(fileURLWithPath: "/Applications/Patched Sur.app", isDirectory: true)
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.createsNewApplicationInstance = true
    configuration.allowsRunningApplicationSubstitution = false
    NSWorkspace.shared.openApplication(at: appURL, configuration: configuration) { (_, error) in
        if error != nil {
            print("Failed to open Patched Sur app, but you can do that yourself.")
            let errorAlert = NSAlert()
            errorAlert.alertStyle = .critical
            errorAlert.informativeText = NSLocalizedString("PO-ST-RL-FAILED-2", comment: "PO-ST-RL-FAILED-2")
            errorAlert.messageText = NSLocalizedString("PO-ST-RL-FAILED", comment: "PO-ST-RL-FAILED")
            errorAlert.runModal()
            return
        }
    }
    sleep(1)
    exit(0)
}

// MARK: Patch Boot.plist


