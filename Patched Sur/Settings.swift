//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import SwiftUI
import SwiftShell

struct Settings: View {
    @State private var showingAlert = false
    let releaseTrack: String
    @Binding var at: Int
    var body: some View {
        ZStack {
            BackGradientView(releaseTrack: releaseTrack)
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("Patched Sur Settings")
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                        Spacer()
                        CustomColoredButton("Back to Home") {
                            at = 0
                        }
                    }
                    HStack {
                        CustomColoredButton("Disable Animations") {
                            _ = try? shellOut(to: "defaults write -g NSAutomaticWindowAnimationsEnabled -bool false")
                            _ = try? shellOut(to: "defaults write -g NSScrollAnimationEnabled -bool false")
                            _ = try? shellOut(to: "defaults write -g NSWindowResizeTime -float 0.001")
                            _ = try? shellOut(to: "defaults write -g QLPanelAnimationDuration -float 0")
                            _ = try? shellOut(to: "defaults write -g NSScrollViewRubberbanding -bool false")
                            _ = try? shellOut(to: "defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false")
                            _ = try? shellOut(to: "defaults write -g NSToolbarFullScreenAnimationDuration -float 0")
                            _ = try? shellOut(to: "defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock autohide-time-modifier -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock autohide-delay -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock expose-animation-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock springboard-show-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock springboard-hide-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.dock springboard-page-duration -float 0")
                            _ = try? shellOut(to: "defaults write com.apple.finder DisableAllAnimations -bool true")
                            _ = try? shellOut(to: "defaults write com.apple.Mail DisableSendAnimations -bool true")
                            _ = try? shellOut(to: "defaults write com.apple.Mail DisableReplyAnimations -bool true")
                            _ = try? shellOut(to: "defaults write NSGlobalDomain NSWindowResizeTime .001")
                            self.showingAlert = true
                        }
                        CustomColoredButton("Enable Animations") {
                            _ = try? shellOut(to: "defaults delete -g NSAutomaticWindowAnimationsEnabled")
                            _ = try? shellOut(to: "defaults delete -g NSScrollAnimationEnabled")
                            _ = try? shellOut(to: "defaults delete -g NSWindowResizeTime")
                            _ = try? shellOut(to: "defaults delete -g QLPanelAnimationDuration")
                            _ = try? shellOut(to: "defaults delete -g NSScrollViewRubberbanding")
                            _ = try? shellOut(to: "defaults delete -g NSDocumentRevisionsWindowTransformAnimation")
                            _ = try? shellOut(to: "defaults delete -g NSToolbarFullScreenAnimationDuration")
                            _ = try? shellOut(to: "defaults delete -g NSBrowserColumnAnimationSpeedMultiplier")
                            _ = try? shellOut(to: "defaults delete com.apple.dock autohide-time-modifier")
                            _ = try? shellOut(to: "defaults delete com.apple.dock autohide-delay")
                            _ = try? shellOut(to: "defaults delete com.apple.dock expose-animation-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.dock springboard-show-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.dock springboard-hide-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.dock springboard-page-duration")
                            _ = try? shellOut(to: "defaults delete com.apple.finder DisableAllAnimations")
                            _ = try? shellOut(to: "defaults delete com.apple.Mail DisableSendAnimations")
                            _ = try? shellOut(to: "defaults delete com.apple.Mail DisableReplyAnimations")
                            _ = try? shellOut(to: "defaults delete NSGlobalDomain NSWindowResizeTime")
                            self.showingAlert = true
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Changes Made Successfully"), message: Text("A reboot is required to apply these changes."), dismissButton: .default(Text("Okay")))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                    .padding(.bottom, 2)
                    Text("Manage Animations. Disabling animations can greatly improve performance on Macs without Metal. A reboot is required to apply these changes.")
                        .font(.caption)
                }.font(.subheadline)
                .foregroundColor(.white)
                .padding(.leading, 2)
                .padding(.horizontal, 50)
            }.padding(.vertical, 40)
        }
        .environment(\.releaseTrack, releaseTrack)
    }
}

struct CustomColoredButton: View {
    @Environment(\.releaseTrack) var releaseTrack
    let text: String
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                if releaseTrack == "Public Beta" {
                    Rectangle().foregroundColor(.blue)
                } else if releaseTrack == "Developer" {
                    Rectangle().foregroundColor(.orange)
                } else if releaseTrack == "Release" {
                    Rectangle().foregroundColor(.green)
                }
                Text(text)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .padding(.horizontal, 4)
            }.fixedSize()
            .cornerRadius(7.5)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    init(_ text: String, action: @escaping () -> ()) {
        self.text = text
        self.action = action
    }
}

extension EnvironmentValues {
    private struct ReleaseTrackKey: EnvironmentKey {
        static let defaultValue = "Release"
    }
    
    public var releaseTrack: String {
        get {
            self[ReleaseTrackKey]
        } set {
            self[ReleaseTrackKey] = newValue
        }
    }
}
