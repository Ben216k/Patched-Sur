//
//  Patched_SurApp.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 9/23/20.
//

import SwiftUI
import Files

class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 584, height: 346),
            styleMask: [.titled, .miniaturizable, .fullSizeContentView, .borderless],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = true
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    private var aboutBoxWindowController: NSWindowController?
    
    func showAboutPanel() {
        if aboutBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable,/* .resizable,*/ .titled]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = "About Patched Sur"
            window.contentView = NSHostingView(rootView: AboutPatchedSur())
            aboutBoxWindowController = NSWindowController(window: window)
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
        }

        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }


}

struct PatchedSurApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var atLocation = 0
    @State var hovered: String?
//    @State var setupWindow = false
    var body: some Scene {
        WindowGroup {
            ContentView(at: $atLocation)
                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
                .accentColor(Color("AccentColor"))
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    if let window = NSApplication.shared.mainWindow {
                        window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isEnabled = false
//                        setupWindow = true
                    }
                })
                .onOpenURL(perform: { url in
                    if AppInfo.canReleaseAttention {
                        switch url {
                        case "patched-sur://patch-kexts", "patched-sur://patch-system":
                            atLocation = 2
                        case "patched-sur://settings", "patched-sur://preferences":
                            atLocation = 4
                        case "patched-sur://install-recovery", "patched-sur://patch-recovery":
                            atLocation = 6
                        case "patched-sur://create-installer":
                            atLocation = 5
                        case "patched-sur://run-updates", "patched-sur://update-macos", "patched-sur://update-patcher":
                            atLocation = 1
                        case "patched-sur://about-my-mac", "patched-sur://about-this-mac":
                            atLocation = 1
                        default:
                            break
                        }
                    }
                    if NSApplication.shared.windows.count > 1 {
                        NSApplication.shared.keyWindow?.close()
                    }
                })
        }.windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            Group {
                CommandGroup(replacing: .newItem) {}
                CommandGroup(replacing: CommandGroupPlacement.importExport) {}
                CommandGroup(replacing: CommandGroupPlacement.appVisibility) {}
                CommandGroup(replacing: CommandGroupPlacement.pasteboard) {}
                CommandGroup(replacing: CommandGroupPlacement.undoRedo) {}
                CommandGroup(replacing: CommandGroupPlacement.textEditing) {}
                CommandGroup(replacing: CommandGroupPlacement.windowArrangement) {}
                CommandGroup(replacing: CommandGroupPlacement.windowList) {}
                CommandGroup(replacing: CommandGroupPlacement.saveItem) {}
                CommandGroup(replacing: CommandGroupPlacement.systemServices) {}
            }
            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
                Button(action: {
                    appDelegate.showAboutPanel()
                }) {
                    Text(.init("PO-MN-ABOUT-PATCHER"))
                }
            }
            CommandGroup(replacing: CommandGroupPlacement.appSettings) {
                Button {
                    if AppInfo.canReleaseAttention {
                        atLocation = 4
                    }
                } label: {
                    Text(.init("PREFERENCES"))
                }.keyboardShortcut(.init(.init(","), modifiers: .command))
            }
            CommandGroup(after: CommandGroupPlacement.appInfo) {
                Button {
                    if AppInfo.canReleaseAttention {
                        atLocation = 3
                    }
                } label: {
                    Text(.init("PO-AMM-TITLE"))
                }
            }
            CommandGroup(replacing: CommandGroupPlacement.help) {
                Button {
                    NSWorkspace.shared.open(URL(string: "https://github.com/BenSova/Patched-Sur/#support")!)
                } label: {
                    Text(.init("PO-MN-HELP"))
                }
            }
            CommandGroup(after: CommandGroupPlacement.help) {
                Button {
                    NSWorkspace.shared.open(URL(string: "https://bensova.gitbook.io/big-sur/postinstall-after-upgrade/updating-macos")!)
                } label: {
                    Text(.init("PO-MN-HELP-OS"))
                }
                Button {
                    NSWorkspace.shared.open(URL(string: "https://bensova.gitbook.io/big-sur/postinstall-after-upgrade/updating-the-patcher-app")!)
                } label: {
                    Text(.init("PO-MN-HELP-PATCHER"))
                }
            }
//            CommandGroup(after: CommandGroupPlacement.help) {
//                
//            }
        }
//        SwiftUI.Settings {
//            Settings(releaseTrack: "Release", at: .constant(-10), hovered: hovered)
//                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
//        }
    }
}

struct PatchedSurSafeApp: App {
    @State var password = ""
    var body: some Scene {
        WindowGroup {
            PatchKextsView(at: .constant(-11), password: $password)
                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
                .accentColor(Color("AccentColor"))
        }
    }
}

struct PatchedSurOSInstallApp: App {
    var body: some Scene {
        WindowGroup {
            UpdateView(at: .constant(-11), buildNumber: "Yes")
                .frame(minWidth: 600, maxWidth: 600, minHeight: 325, maxHeight: 325)
                .accentColor(Color("AccentColor"))
        }
    }
}

extension Color {
    static let background = Color("Background")
    static let secondaryBackground = Color("BackgroundSecondary")
    static let tertiaryBackground = Color("BackgroundTertiary")
}

final class AppInfo {
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let build = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
    static let patchesV = { () -> PSPatchV in
        guard let patches = try? PSPatchVs(fromURL: "https://bensova.github.io/patched-sur/patches.json") else {
            return .init(version: "fcd8a3b", compatible: 70, url: "https://github.com/BenSova/Patched-Sur-Patches/archive/refs/tags/fcd8a3b.zip", updateLog: "")
        }
        let patche = patches.filter { $0.compatible <= Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)! }.last!
        return patche
    }()
    static var safe = false
    static var debug = false
    static var reinstall = false
    static var usePredownloaded = false
    static var preventUpdate = false
    static var startingInstall = false
    static var canReleaseAttention = true
    static var nothing = false
    static var openGL = false
    static var lol = false
}

struct PatchedSurLogger: TextOutputStream {
    var logLocation = ""
    var logContents = ""
    let logFile: File

    mutating func write(_ string: String) {
        print(string, terminator: "")
        do {
            logContents.append(string)
            try logFile.write(logContents)
        } catch {
            print("Unable to write message to log. This is unexpected." as Any)
        }
    }

    init() {
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy-hh:mm.ss"
        let stringDate = format.string(from: Date())
        print("Log file will be stored at: ~/.patched-sur/logs/Post-\(stringDate).log" as Any)
        logLocation = ".patched-sur/logs/Post-\(stringDate).log"
        do {
            try Folder.home.createFileIfNeeded(at: logLocation)
            logFile = try File(path: "~/\(logLocation)")
        } catch {
            fatalError("UNABLE TO CREATE LOG FILE, THIS IS NOT GOOD FOR DEBUGGING")
        }
    }
}

func presentAlert(m: String, i: String, s: NSAlert.Style = .critical) {
    let errorAlert = NSAlert()
    errorAlert.alertStyle = s
    errorAlert.informativeText = i
    errorAlert.messageText = m
    errorAlert.runModal()
}
