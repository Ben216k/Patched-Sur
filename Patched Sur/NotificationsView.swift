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
    @Binding var p: Int
    var body: some View {
        VStack {
            Text("Update Notifications")
                .font(Font.body.bold())
            Text("Since your Mac is unsupported, Software Update will never inform you about macOS updates, because it doesn't have anything new that supports your Mac. However, Patched Sur can provide this functionality on it's own, also providing for notifications for updates to the patcher if you would like.")
                .padding()
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .font(.body)
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
                                .foregroundColor(hovered != "NOTHING" ? (notifications == "NOTHING" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Nothing")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "NOTHING" ? .white : .primary)
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
                                .foregroundColor(hovered != "MACOS" ? (notifications == "MACOS" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("macOS")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "MACOS" ? .white : .primary)
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
                                .foregroundColor(hovered != "PATCHEDSUR" ? (notifications == "PATCHEDSUR" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Patched Sur")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "PATCHEDSUR" ? .white : .primary)
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
                                .foregroundColor(hovered != "BOTH" ? (notifications == "BOTH" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Both")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(notifications == "BOTH" ? .white : .primary)
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
                        autoUpdate = "AUTOUPDATE"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "AUTOUPDATE" ? (autoUpdate == "AUTOUPDATE" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Patched Sur")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(autoUpdate == "AUTOUPDATE" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "AUTOUPDATE" : ""
                    }.padding(.trailing, 5)
                    Button {
                        autoUpdate = "NOUPDATE"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(hovered != "NOUPDATE" ? (autoUpdate == "NOUPDATE" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.2)) : Color.accentColor.opacity(0.5))
                                .cornerRadius(10)
                            Text("Nothing")
                                .padding(6)
                                .padding(.horizontal, 4)
                                .foregroundColor(autoUpdate == "NOUPDATE" ? .white : .primary)
                        }.fixedSize()
                    }.buttonStyle(BorderlessButtonStyle())
                    .onHover {
                        hovered = $0 ? "NOUPDATE" : ""
                    }
                }
            }.fixedSize()
            // MARK: - Confirm
            HStack {
                Button {
                    p = 2
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(hovered != "BACK" ? Color.accentColor.opacity(0.2) : Color.accentColor.opacity(0.5))
                            .cornerRadius(10)
                        Text("Back")
                            .padding(6)
                            .padding(.horizontal, 4)
                            .foregroundColor(.primary)
                    }.fixedSize()
                }.buttonStyle(BorderlessButtonStyle())
                .onHover {
                    hovered = $0 ? "BACK" : ""
                }
                Button {
                    
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(hovered != "CONFIRM" ? Color.accentColor.opacity(0.8) : Color.accentColor.opacity(0.5))
                            .cornerRadius(10)
                        Text("Confirm")
                            .padding(6)
                            .padding(.horizontal, 4)
                            .foregroundColor(.white)
                    }.fixedSize()
                }.buttonStyle(BorderlessButtonStyle())
                .onHover {
                    hovered = $0 ? "CONFIRM" : ""
                }
            }.padding(.top, 5)
        }
    }
}
