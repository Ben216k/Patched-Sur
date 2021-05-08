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
            Text(.init("PO-UP-NOTIF-TITLE-2"))
                .font(Font.system(size: 15).bold())
            Text(.init("PO-UP-NOTIF-DESCRIPTION-2"))
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
                        Text(.init("YES"))
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
                        Text(.init("NO"))
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
                    Text("Patched Sur")
                        .padding(.leading, 12)
                        .foregroundColor(Color("Accent"))
                    
                    VIButton(id: "PYES", h: $hovered) {
                        if notifications == "PATCHER" || notifications == "BOTH" {
                            Image("CheckCircle")
                        }
                        Text(.init("YES"))
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
                        Text(.init("NO"))
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
                    Text(.init("BACK"))
                } onClick: {
                    withAnimation {
                        showNotifis = false
                    }
                }.inPad()
                .btColor(.gray)
                VIButton(id: "SET", h: $hovered) {
                    Text(.init("CONFIRM"))
                    Image("ForwardArrowCircle")
                } onClick: {
                    if notifications == "NOTHING" {
                        presentAlert(m: NSLocalizedString("PO-NOTIF-SETUP-DONE", comment: "PO-NOTIF-SETUP-DONE"), i: NSLocalizedString("PO-NOTIF-SETUP-DONE-2", comment: "PO-NOTIF-SETUP-DONE-2"), s: .informational)
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
                                    presentAlert(m: NSLocalizedString("PO-NOTIF-SETUP-DENY", comment: "PO-NOTIF-SETUP-DENY"), i: "\(NSLocalizedString("PO-NOTIF-SETUP-DENY-2", comment: "PO-NOTIF-SETUP-DENY-2"))\n\n\(error.localizedDescription)", s: .informational)
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
                                presentAlert(m: NSLocalizedString("PO-NOTIF-SETUP-ALMOST", comment: "PO-NOTIF-SETUP-ALMOST"), i: NSLocalizedString("PO-NOTIF-SETUP-ALMOST-2", comment: "PO-NOTIF-SETUP-ALMOST-2"), s: .informational)
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
                                            presentAlert(m: NSLocalizedString("PO-NOTIF-SETUP-DONE", comment: "PO-NOTIF-SETUP-DONE"), i: NSLocalizedString("PO-NOTIF-SETUP-DONE-2", comment: "PO-NOTIF-SETUP-DONE-2"), s: .informational)
                                            isRunning = false
                                            withAnimation {
                                                showNotifis = false
                                            }
                                        } catch {
                                            presentAlert(m: NSLocalizedString("PO-NOTIF-SETUP-FAILED", comment: "PO-NOTIF-SETUP-FAILED"), i: error.localizedDescription, s: .informational)
                                            isRunning = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    let al = NSAlert()
                    al.informativeText = NSLocalizedString("PO-NOTIF-SETUP-PERMS-2", comment: "PO-NOTIF-SETUP-PERMS-2")
                    al.messageText = NSLocalizedString("PO-NOTIF-SETUP-PERMS", comment: "PO-NOTIF-SETUP-PERMS")
                    al.addButton(withTitle: NSLocalizedString("CANCEL", comment: "CANCEL"))
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
