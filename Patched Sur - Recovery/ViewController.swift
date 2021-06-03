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
        let selectInfo = volumeSelect.selectedItem!.title
        if patchKextsButton.title != "Restart to Finish" {
            print("Start patch kexts pressed!")
            patchKextsButton.stringValue = NSLocalizedString("PATCHING-KEXTS", comment: "PATCHING-KEXTS")
            patchKextsButton.title = NSLocalizedString("PATCHING-KEXTS", comment: "PATCHING-KEXTS")
            patchKextsButton.isEnabled = false
            volumeSelect.isEnabled = false
            print("Checking if we're on a Late 2013 iMac")
            let model = runCommandReturnStr(binary: "/usr/sbin/sysctl", arguments: ["-n", "hw.model"])
            print("Detected Mac Model: \(model!.message)")
            if model!.message.hasPrefix("iMac14,") {
                presentAlert(m: "Patch Kexts Unnecessary", i: "You don't need to patch the kexts on Late 2013 iMacs. Big Sur is already running at full functionality.", s: .informational)
                patchKextsButton.stringValue = "Start Patch Kexts"
                patchKextsButton.title = "Start Patch Kexts"
                patchKextsButton.isEnabled = true
                volumeSelect.isEnabled = true
                return
            }
            DispatchQueue.global(qos: .background).async { [self] in
                print("Starting patch kexts")
//                try call("'/Volumes/Image Volume/patch-kexts.sh' '/Volumes/\(volumeSelect.selectedItem!.title)'")
                _ = runCommandReturnStr(binary: "/bin/rm", arguments: ["-rf", "/Volumes/\(selectInfo) - Data/Applications/Patched Sur.app"])
                _ = runCommandReturnStr(binary: "/bin/cp", arguments: ["-a", "/Volumes/Image Volume/Patched Sur.app", "/Volumes/\(selectInfo) - Data/Applications/Patched Sur.app"])
                let patchKextsOut = runCommandReturnStr(binary: "/bin/bash", arguments: ["/Volumes/Image Volume/PatchSystem.sh", "--detect", "/Volumes/\(selectInfo)"])
                if patchKextsOut!.status == 0 {
                    DispatchQueue.main.async {
                        patchKextsButton.stringValue = NSLocalizedString("RESTART-TO-FINISH", comment: "RESTART-TO-FINISH")
                        patchKextsButton.title = NSLocalizedString("RESTART-TO-FINISH", comment: "RESTART-TO-FINISH")
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
                } else {
                    DispatchQueue.main.async {
                        patchKextsButton.stringValue = "Show Error Log"
                        patchKextsButton.title = "Show Error Log"
                        patchKextsButton.isEnabled = true
                        volumeSelect.isEnabled = false
                        errorText.string = patchKextsOut!.message
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
            _ = runCommandReturnStr(binary: "/sbin/reboot", arguments: [])
        }
    }
    
    @available(OSX 10.10, *)
    override func viewDidLoad() {
        super.viewDidLoad()
        errorText.isSelectable = false
        errorText.isEditable = false
        errorScroll.isHidden = true
        errorText.backgroundColor = NSColor(named: "ErrorThing") ?? NSColor.windowBackgroundColor
        errorText.textColor = NSColor.red
        errorText.font = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
//        errorScroll.cor
        versionText.stringValue = "v\(AppInfo.version) (\(AppInfo.build))"
        volumeSelect.removeAllItems()
        volumeSelect.addItem(withTitle: NSLocalizedString("SELECT-A-VOLUME", comment: "Select a Volume"))
        if let volumesNoPhrase = runCommandReturnStr(binary: "/bin/ls", arguments: ["-1", "/Volumes"]) {
            var volumes = volumesNoPhrase.message.split(separator: "\n")
            volumes = volumes.filter {
//                do {
//                    try call("[[ -d '/Volumes/\($0)/System/Library/Extensions' ]]")
//                    try call("""
//                    SVPL='/Volumes/\($0)/System/Library/CoreServices/SystemVersion.plist'
//                    SVPL_VER=`fgrep '<string>10' "$SVPL" | sed -e 's@^.*<string>10@10@' -e 's@</string>@@' | uniq -d`
//                    SVPL_BUILD=`grep '<string>[0-9][0-9][A-Z]' "$SVPL" | sed -e 's@^.*<string>@@' -e 's@</string>@@'`
//                    echo $SVPL_BUILD | grep -q '^20'
//                    """)
//                    return true
//                } catch {
//                    return false
//                }
                if $0 == "Install macOS Big Sur" || $0 == "macOS Base System" || $0 == "Image Volume" {
                    return false
                } else if $0 == "BOOTCAMP" || $0 == "Update" || ($0.hasSuffix("- Data")) {
                    return false
                }
                return true
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

// The below code is taken from StarPlayrX's BigMac2 Patcher.

func runCommandReturnStr(binary: String, arguments: [String]) -> (message: String, status: Int)? {
        
    let process = Process()
    
//    if #available(OSX 10.13, *) {
//        process.executableURL = URL(string: "file://" + binary)
//    } else {
        // Fallback on earlier versions
        process.launchPath = binary
//    }
    
    process.arguments = arguments
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    process.launch()
    process.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
     
    if let output = String(data: data, encoding: String.Encoding.utf8), !output.isEmpty {
        process.terminate()
        return (output, Int(process.terminationStatus))
    }
    
    return ("", 0)
}
