//
//  AppDelegate.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/23/20.
//

import Cocoa
import VeliaUI

class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 584, height: 346),
            styleMask: [.titled, .miniaturizable, .closable, .fullSizeContentView, .borderless],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = true
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
//        let queue = DispatchQueue(label: "DownloadKexts")
//        queue.
        // https://stackoverflow.com/a/34574966
//        queue.suspend()
        _ = try? call("killall curl")
        _ = try? call("killall createinstallmedia")
    }

}

class AppInfo {
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let build = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
    static let patchesV = { () -> PSPatchV in
        guard let patches = try? PSPatchVs(fromURL: "https://bensova.github.io/patched-sur/patches.json") else {
            return .init(version: "fcd8a3b", compatible: 70, url: "https://github.com/BenSova/Patched-Sur-Patches/archive/refs/tags/fcd8a3b.zip", updateLog: "")
        }
        let patche = patches.filter { $0.compatible <= Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)! }.last!
        return patche
    }()
    static func localKey(_ key: String, def: String? = nil) -> String {
        NSLocalizedString(key, comment: def ?? key).description
    }

}

extension AnyTransition {
    static var moveAway: AnyTransition {
        return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))

    }
}

public extension String {
    init(localKey: String, def: String? = nil) {
        self = NSLocalizedString(localKey, comment: def ?? localKey).description
    }
}
