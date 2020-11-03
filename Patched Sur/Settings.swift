//
//  AboutMyMac.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 10/31/20.
//

import SwiftUI

struct Settings: View {
    let releaseTrack: String
    @Binding var at: Int
    var body: some View {
        ZStack {
            BackGradientView(releaseTrack: releaseTrack)
            HStack {
                SideImageView(releaseTrack: releaseTrack)
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Button {
                            at = 0
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.blue)
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.green)
                                }
                                Text("Disable Animations")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .padding(.horizontal, 4)
                            }.fixedSize()
                            .cornerRadius(7.5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Button {
                            at = 1
                        } label: {
                            ZStack {
                                if releaseTrack == "Public Beta" {
                                    Rectangle().foregroundColor(.blue)
                                } else if releaseTrack == "Developer" {
                                    Rectangle().foregroundColor(.red)
                                } else if releaseTrack == "Release" {
                                    Rectangle().foregroundColor(.green)
                                }
                                Text("Enable Animations")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .padding(.horizontal, 4)
                            }.fixedSize()
                            .cornerRadius(7.5)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }.padding(.top, 10)
                }.font(.subheadline)
                .foregroundColor(.white)
            }
        }
    }
}





/*
shellOut(to: "defaults write -g NSAutomaticWindowAnimationsEnabled -bool false")
shellOut(to: "defaults write -g NSScrollAnimationEnabled -bool false")
shellOut(to: "defaults write -g NSWindowResizeTime -float 0.001")
shellOut(to: "defaults write -g QLPanelAnimationDuration -float 0")
shellOut(to: "defaults write -g NSScrollViewRubberbanding -bool false")
shellOut(to: "defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false")
shellOut(to: "defaults write -g NSToolbarFullScreenAnimationDuration -float 0")
shellOut(to: "defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0")
shellOut(to: "defaults write com.apple.dock autohide-time-modifier -float 0")
shellOut(to: "defaults write com.apple.dock autohide-delay -float 0")
shellOut(to: "defaults write com.apple.dock expose-animation-duration -float 0")
shellOut(to: "defaults write com.apple.dock springboard-show-duration -float 0")
shellOut(to: "defaults write com.apple.dock springboard-hide-duration -float 0")
shellOut(to: "defaults write com.apple.dock springboard-page-duration -float 0")
shellOut(to: "defaults write com.apple.finder DisableAllAnimations -bool true")
shellOut(to: "defaults write com.apple.Mail DisableSendAnimations -bool true")
shellOut(to: "defaults write com.apple.Mail DisableReplyAnimations -bool true")
shellOut(to: "defaults write NSGlobalDomain NSWindowResizeTime .001")
*/
