//
//  ViewController.swift
//  Patched Sur - Recovery
//
//  Created by Ben Sova on 3/24/21.
//

import Cocoa
import AppKit

class ViewController: NSViewController {
    @IBOutlet var patchKextsButton: NSButton!
    @IBOutlet var versionText: NSTextField!
    @IBOutlet var volumeSelect: NSPopUpButton!
    @IBOutlet var errorScroll: NSScrollView!
    @IBOutlet var errorText: NSTextView!
    @IBOutlet var titleText: NSTextField!
    
    @IBAction func startPatchKexts(_ sender: Any) {
        if patchKextsButton.title != "Restart to Finish" {
            print("Start patch kexts pressed!")
            patchKextsButton.stringValue = "Patching Kexts"
            patchKextsButton.title = "Patching Kexts"
            patchKextsButton.isEnabled = false
            volumeSelect.isEnabled = false
            print("Checking if we're on a Late 2013 iMac")
            var model = (try? call("nvram 4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product")) ?? "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product \((try? call("sysctl -n hw.model")) ?? "MacModelX,Y")"
            model.removeFirst("4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product ".count)
            print("Detected Mac Model: \(model)")
            if !model.hasPrefix("iMac14,") {
                
            } else {
                presentAlert(m: "Patch Kexts Unnecessary", i: "You don't need to patch the kexts on Late 2013 iMacs. Big Sur is already running at full functionality.", s: .informational)
                patchKextsButton.stringValue = "Start Patch Kexts"
                patchKextsButton.title = "Start Patch Kexts"
                patchKextsButton.isEnabled = true
                volumeSelect.isEnabled = true
                return
            }
            print("Checking if we're in recovery")
            #if !DEBUG
            guard (try? call("[[ -d '/Volumes/Image Volume' ]]")) != nil else {
                print("We're not! This can't be done!")
                presentAlert(m: "This App Must Be Run in Recovery Mode", i: "This app is not designed for running in full macOS Big Sur, but rather an installer USB. If you want to patch the kexts while booted into macOS Big Sur, you need to get the full post-install app.\n\nThis could possibly be found:\n- Inside your Applications folder\n- On the installer usb\n- From GitHub inside Post-Install-App.dmg.\n\nYou could also reboot into the installer USB (or recovery mode if you installed the recovery patch), then you can use this app, it'll appear right under Disk Utility.")
                patchKextsButton.stringValue = "Start Patch Kexts"
                patchKextsButton.title = "Start Patch Kexts"
                patchKextsButton.isEnabled = true
                volumeSelect.isEnabled = true
                return
            }
            #endif
            DispatchQueue.global(qos: .background).async { [self] in
                print("Starting patch kexts")
                do {
                    try call("sleep 2")
//                    try call("'/Volumes/Image Volume/patch-kexts.sh' '/Volumes/\(volumeSelect.selectedItem!.title)'")
                    DispatchQueue.main.async {
                        patchKextsButton.stringValue = "Restart to Finish"
                        patchKextsButton.title = "Restart to Finish"
                        patchKextsButton.isEnabled = true
                        volumeSelect.isEnabled = false
                        errorText.string = ""
                        errorScroll.isHidden = true
                        // Display
                        errorText.needsDisplay = true
                        errorScroll.needsDisplay = true
                        volumeSelect.needsDisplay = true
                        patchKextsButton.needsDisplay = true
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        patchKextsButton.stringValue = "Show Error Log"
                        patchKextsButton.title = "Show Error Log"
                        patchKextsButton.isEnabled = true
                        volumeSelect.isEnabled = false
                        errorText.string = error.localizedDescription
                        errorScroll.isHidden = false
                        // Display
                        errorText.needsDisplay = true
                        errorScroll.needsDisplay = true
                        volumeSelect.needsDisplay = true
                        patchKextsButton.needsDisplay = true
                    }
                }
            }
        } else {
            _ = try? call("reboot")
        }
    }
    
    @available(OSX 10.10, *)
    override func viewDidLoad() {
        super.viewDidLoad()
        errorText.isSelectable = false
        errorText.isEditable = false
        errorScroll.isHidden = true
        errorText.backgroundColor = NSColor(deviceRed: 0.96, green: 0.89, blue: 0.89, alpha: 1)
        errorText.textColor = NSColor.red
        errorText.font = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
//        errorScroll.cor
        versionText.stringValue = "v\(AppInfo.version) (\(AppInfo.build))"
        volumeSelect.removeAllItems()
        volumeSelect.addItem(withTitle: "Select a Volume")
        if let volumesNoPhrase = try? call("ls -1 /Volumes") {
            var volumes = volumesNoPhrase.split(separator: "\n")
            volumes = volumes.filter {
                do {
                    try call("[[ -d '/Volumes/\($0)/System/Library/Extensions' ]]")
                    try call("""
                    SVPL='/Volumes/\($0)/System/Library/CoreServices/SystemVersion.plist'
                    SVPL_VER=`fgrep '<string>10' "$SVPL" | sed -e 's@^.*<string>10@10@' -e 's@</string>@@' | uniq -d`
                    SVPL_BUILD=`grep '<string>[0-9][0-9][A-Z]' "$SVPL" | sed -e 's@^.*<string>@@' -e 's@</string>@@'`
                    echo $SVPL_BUILD | grep -q '^20'
                    """)
                    return true
                } catch {
                    return false
                }
            }
            volumes.forEach {
                volumeSelect.addItem(withTitle: String($0))
            }
//            if volumes.contains("Macintosh HD") {
//                volumeSelect.selectItem(withTitle: "Macintosh HD")
//            } else if volumes.contains("Macintosh SSD") {
//                volumeSelect.selectItem(withTitle: "Macintosh SSD")
//            } else if volumes.filter({ $0.contains("Big") || $0.contains("11") || $0.contains("Sur") }).count > 0 {
//                volumeSelect.selectItem(withTitle: String(volumes.filter { $0.contains("11") || $0.contains("Sur") || $0.contains("Big") }[0]))
//            }
        }

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

class AppInfo {
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    static let build = Int(Bundle.main.infoDictionary!["CFBundleVersion"] as! String)!
}

func presentAlert(m: String, i: String, s: NSAlert.Style = .critical) {
    let errorAlert = NSAlert()
    errorAlert.alertStyle = s
    errorAlert.informativeText = i
    errorAlert.messageText = m
    errorAlert.runModal()
}
