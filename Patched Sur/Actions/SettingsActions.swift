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
}

func enableAnimations() {
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
}

// MARK: Manage Graphics Switching

func enableGxSwitching(p password: String) {
    do {
        print("Stopping displaypolicyd...")
        _ = try? call("launchctl stop system/com.apple.displaypolicyd", p: password)
        print("Enabling Automatic Graphics Switching...")
        try call("launchctl disable system/com.apple.displaypolicyd", p: password)
        presentAlert(m: "Graphics Switching Enabled", i: "Now graphics will switch automatically! A restart might be required for changes to take effect.", s: .informational)
    } catch {
        presentAlert(m: "Failed to Enable Graphics Switching", i: error.localizedDescription, s: .critical)
    }
}

func disableGxSwitching(p password: String) {
    do {
        print("Disabling Automatic Graphics Switching...")
        try call("launchctl enable system/com.apple.displaypolicyd", p: password)
        print("Starting displaypolicyd...")
        _ = try? call("launchctl kickstart system/com.apple.displaypolicyd", p: password)
        presentAlert(m: "Graphics Switching Disabled", i: "Now graphics will no longer switch automatically! A restart might be required for changes to take effect.", s: .informational)
    } catch {
        presentAlert(m: "Failed to Diable Graphics Switching", i: error.localizedDescription, s: .critical)
    }
}

// MARK: Clean Leftovers

func cleanLeftovers() {
    _ = try? call("rm -rf ~/.patched-sur/InstallAssistant.pkg")
    _ = try? call("rm -rf ~/.patched-sur/Install\\ macOS Big\\ Sur*.app")
    _ = try? call("rm -rf ~/.patched-sur/InstallInfo.txt")
    _ = try? call("rm -rf ~/.patched-sur/trash")
    presentAlert(m: "Cleaned Leftovers", i: "The files have been deleted, you should see some more free space (assuming that there actually were big files to be cleaned).", s: .informational)
}
