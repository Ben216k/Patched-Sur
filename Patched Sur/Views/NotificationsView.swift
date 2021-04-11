//
//  NotificationsView.swift
//  Patched Sur
//
//  Created by Ben Sova on 2/25/21.
//

import VeliaUI
import UserNotifications

struct NotificationsView: View {
    @State var hovered: String?
    @State var notifications = "NOTHING"
    @State var autoUpdate = "NOUPDATE"
    @Binding var showNotifis: Bool
    @State var allowNotifications = false
    @Binding var showPass: Bool
    @Binding var password: String
    @State var isRunning = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Update Notifications")
                .font(Font.system(size: 15).bold())
            Text("Since your Mac is unsupported, Software Update will never inform you about macOS updates, because it doesn't have anything new that supports your Mac. However, Patched Sur can provide this functionality on it's own, also providing for notifications for updates to the patcher if you would like.\n\nReceive Notifications for:")
                .padding(.top, 5)
                .multilineTextAlignment(.leading)
                .font(.system(size: 11))
            
            // MARK: - Get Notifications For
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("Accent"))
                    .opacity(0.1)
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Accent"), style: StrokeStyle(lineWidth: 2))
                HStack {
                    Text("macOS")
                        .padding(.leading, 12)
                        .foregroundColor(Color("Accent"))
                    
                    VIButton(id: "MYES", h: $hovered) {
                        if notifications == "MACOS" || notifications == "BOTH" {
                            Image("CheckCircle")
                        }
                        Text("Yes")
                    } onClick: {
                        if notifications != "MACOS" {
                            notifications = notifications == "PATCHER" ? "BOTH" : "MACOS"
                        }
                    }.inPad()
                    .btColor(notifications == "MACOS" || notifications == "BOTH" ? Color("Accent") : Color("Accent").opacity(0.5))
                    .useHoverAccent()
                    .padding(.horizontal, 2)
                    
                    VIButton(id: "MNO", h: $hovered) {
                        if notifications != "MACOS" && notifications != "BOTH" {
                            Image("CheckCircle")
                        }
                        Text("No")
                    } onClick: {
                        if notifications != "PATCHER" {
                            notifications = notifications == "BOTH" ? "PATCHER" : "NONE"
                        }
                    }.inPad()
                    .btColor(notifications != "MACOS" && notifications != "BOTH" ? Color("Accent") : Color("Accent").opacity(0.5))
                    .useHoverAccent()
                }
            }.fixedSize()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("Accent"))
                    .opacity(0.1)
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("Accent").opacity(0.8), style: StrokeStyle(lineWidth: 2))
                HStack {
                    Text("Patcher")
                        .padding(.leading, 12)
                        .foregroundColor(Color("Accent"))
                    
                    VIButton(id: "PYES", h: $hovered) {
                        if notifications == "PATCHER" || notifications == "BOTH" {
                            Image("CheckCircle")
                        }
                        Text("Yes")
                    } onClick: {
                        if notifications != "PATCHER" {
                            notifications = notifications == "MACOS" ? "BOTH" : "PATCHER"
                        }
                    }.inPad()
                    .btColor(notifications == "PATCHER" || notifications == "BOTH" ? Color("Accent") : Color("Accent").opacity(0.5))
                    .useHoverAccent()
                    .padding(.horizontal, 2)
                    
                    VIButton(id: "PNO", h: $hovered) {
                        if notifications != "PATCHER" && notifications != "BOTH" {
                            Image("CheckCircle")
                        }
                        Text("No")
                    } onClick: {
                        if notifications != "MACOS" {
                            notifications = notifications == "BOTH" ? "MACOS" : "NONE"
                        }
                    }.inPad()
                    .btColor(notifications != "PATCHER" && notifications != "BOTH" ? Color("Accent") : Color("Accent").opacity(0.5))
                    .useHoverAccent()
                }
            }.fixedSize()
            
            HStack {
                VIButton(id: "BACK", h: $hovered) {
                    Image("BackArrowCircle")
                    Text("Back")
                } onClick: {
                    withAnimation {
                        showNotifis = false
                    }
                }.inPad()
                .btColor(.gray)
                VIButton(id: "SET", h: $hovered) {
                    Text("Confirm")
                    Image("ForwardArrowCircle")
                } onClick: {
                    if notifications == "NOTHING" {
                        presentAlert(m: "Setup Notifications!", i: "Patched Sur will correctly notify you about the updates based on your new preferences.", s: .informational)
                        return
                    }
                    isRunning = true
                    UserDefaults.standard.setValue(notifications, forKey: "Notifications")
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                        if let error = error {
                            print("Failed to allow notifications")
                            print(error.localizedDescription)
                            if isRunning {
                                _ = try? call("sleep 0.3")
                                NSApplication.shared.abortModal()
                                DispatchQueue.main.async {
                                    presentAlert(m: "Patched Sur Cannot Send Notifications", i: "You must have denied Patched Sur from sending notifications. If you want Patched Sur to send notifications, open System Preferences > Notifications > Patched Sur then allow notifications.\n\nError: \(error.localizedDescription)", s: .informational)
                                    isRunning = false
                                }
                                return
                            }
                        }

                        if granted {
                            print("Allowed notifications!")
                            _ = try? call("sleep 0.3")
                            NSApplication.shared.abortModal()
                            DispatchQueue.main.async {
                                presentAlert(m: "Almost there!", i: "To finish setting up notifications, Patched Sur requires making a user daemon that will check every once in a while. To set this up, the patcher needs to have root access, so you'll be prompted to input your password, then you'll be done!", s: .informational)
                                withAnimation {
                                    showPass = true
                                }
                                DispatchQueue.global(qos: .background).async {
                                    while showPass {
                                        _ = try? call("sleep 0.2")
                                    }
                                    if password == "" {
                                        isRunning = false
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        do {
                                            print("Setting up Launchctl...")
                                            _ = try? call("launchctl unload /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
                                            _ = try? call("rm -rf /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
                                            try call("curl -Lo /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist https://raw.githubusercontent.com/BenSova/Patched-Sur/main/Extra%20Files/PatchedSurDaemon.plist", p: password)
                                            try call("launchctl load -w /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
                                            _ = try? call("launchctl enable system/u-bensova.Patched-Sur.Daemon", p: password)
                                            print("Saving configuration...")
                                            UserDefaults.standard.setValue(notifications, forKey: "Notifications")
                                            UserDefaults.standard.setValue(autoUpdate, forKey: "AutoUpdate")
                                            presentAlert(m: "Setup Notifications!", i: "Patched Sur will notify you about the updates you want based on your new preferences.", s: .informational)
                                            isRunning = false
                                            withAnimation {
                                                showNotifis = false
                                            }
                                        } catch {
                                            presentAlert(m: "Failed to Configure Daemon", i: error.localizedDescription, s: .informational)
                                            isRunning = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let al = NSAlert()
                    al.informativeText = "Before the patcher can send notifications for available updates, the patcher needs permission to send the notifications."
                    al.messageText = "Patched Sur needs permissions to send notifications."
                    al.addButton(withTitle: "Cancel")
                    switch al.runModal() {
                    case .alertFirstButtonReturn:
                        isRunning = false
                        return
                    default:
                        break
                    }
                }.inPad()
            }.padding(.bottom)
            
            // MARK: - Final Setup
            
//            EmptyView()
//            .sheet(isPresented: $showPassword) {
//                ZStack(alignment: .topTrailing) {
//                    VStack {
//                        if !allowNotifications {
//                            HStack {
//                                Text("Patched Sur Requires Your Password to Setup a Daemon").bold()
//                                    .font(Font.body.bold())
//                                Spacer()
//                            }.padding(.bottom)
//                            EnterPasswordButton(password: $password) {
//                                do {
//                                    print("Setting up Launchctl...")
//                                    _ = try? call("launchctl unload /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
//                                    _ = try? call("rm -rf /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
//                                    try call("curl -Lo /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist https://raw.githubusercontent.com/BenSova/Patched-Sur/main/Extra%20Files/PatchedSurDaemon.plist", p: password)
//                                    try call("launchctl load -w /Library/LaunchAgents/u-bensova.Patched-Sur.Daemon.plist", p: password)
//                                    _ = try? call("launchctl enable system/u-bensova.Patched-Sur.Daemon", p: password)
//                                    print("Saving configuration...")
//                                    UserDefaults.standard.setValue(notifications, forKey: "Notifications")
//                                    UserDefaults.standard.setValue(autoUpdate, forKey: "AutoUpdate")
//                                    print("Prompting for allow notifications...")
//                                    allowNotifications = true
//                                } catch {
//                                    showPassword = false
//                                    presentAlert(m: "Failed to Configure Daemon", i: error.localizedDescription, s: .informational)
//                                }
//                                AppInfo.canReleaseAttention = true
//                            }
//                        } else {
//                            Text("Patched Sur needs permissions to send notifications to continue.")
//                                .onAppear {
//                                    if notifications == "NOTHING" {
////                                        presentAlert(m: "Setup Notifications!", i: "Patched Sur will correctly notify you about the updates based on your new preferences.", s: .informational)
//                                        showPassword = false
//                                        allowNotifications = false
//                                        showNotifis = false
//                                    } else {
//                                        let center = UNUserNotificationCenter.current()
//                                        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
//                                            if let error = error {
//                                                print("Failed to allow notifications")
//                                                print(error.localizedDescription)
////                                                presentAlert(m: "Patched Sur Cannot Send Notifcations", i: "You must of denied Patched Sur from sending notifications. If you want Patched Sur to send notifcations, open System Preferences > Notifications > Patched Sur then allow notifcations.\n\nError: \(error.localizedDescription)", s: .informational)
//                                            }
//
//                                            if granted {
//                                                print("Allowed notifcations!")
////                                                presentAlert(m: "Setup Notifications!", i: "Patched Sur will correctly notify you about the updates based on your new preferences.", s: .informational)
//                                            }
//                                        }
//                                        showPassword = false
//                                        allowNotifications = false
//                                        showNotifis = false
//                                    }
//                                }
//                        }
//                    }
//                }.padding(20)
//            }
        }
        .onAppear {
            notifications = UserDefaults.standard.string(forKey: "Notifications") ?? "NOTHING"
            autoUpdate = UserDefaults.standard.string(forKey: "AutoUpdate") ?? "NOUPDATE"
        }
    }
}
