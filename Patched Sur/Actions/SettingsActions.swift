//
//  SettingsActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 3/10/21.
//

import Foundation

func disableAnimations() {
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
