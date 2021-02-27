//
//  NotificationsView.swift
//  Patched Sur
//
//  Created by Ben Sova on 2/25/21.
//

import SwiftUI

struct NotificationsView: View {
    @State var hovered = ""
    @State var notifications = "NOTHING"
    @State var autoUpdate = "NOUPDATE"
    var body: some View {
        VStack {
            Text("Update Notifications")
                .bold()
            Text("Since your Mac is unsupported, Software Update will never inform you about macOS updates, because it doesn't have anything new that supports your Mac. However, Patched Sur can provide this functionality on it's own, also providing for notifications for updates to the patcher if you would like.")
                .padding(20)
                .multilineTextAlignment(.center)
            // MARK: - Get Notifications For
            ZStack {
                Rectangle()
                    .foregroundColor(Color.accentColor.opacity(0.3))
                    .cornerRadius(10)
                HStack(spacing: 0) {
                    Text("Get notifications for")
                        .padding(6)
                        .padding(.leading, 4)
                    Button {
                        notifications = "NOTHING"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "NOTHING" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Nothing")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "NOTHING" : ""
                    }.padding(.trailing, 5)
                    Button {
                        notifications = "MACOS"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "MACOS" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("macOS")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "MACOS" : ""
                    }.padding(.trailing, 5)
                    Button {
                        notifications = "PATCHEDSUR"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "PATCHEDSUR" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Patched Sur")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "PATCHEDSUR" : ""
                    }.padding(.trailing, 5)
                    Button {
                        notifications = "BOTH"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "BOTH" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Both")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "BOTH" : ""
                    }
                }
            }.fixedSize()
            // MARK: - Automatically Update Patched Sur
            ZStack {
                Rectangle()
                    .foregroundColor(Color.accentColor.opacity(0.3))
                    .cornerRadius(10)
                HStack(spacing: 0) {
                    Text("Automatically Update")
                        .padding(6)
                        .padding(.leading, 4)
                    Button {
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "AUTOUPDATE" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Patched Sur")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "AUTOUPDATE" : ""
                    }.padding(.trailing, 5)
                    Button {
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "NOUPDATE" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Nothing")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(.white)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "NOUPDATE" : ""
                    }
                }
            }.fixedSize()
            // MARK: - Go Back
            TextAndButtonView(t: "Go", b: "Back") {
                
            }
        }
    }
}
