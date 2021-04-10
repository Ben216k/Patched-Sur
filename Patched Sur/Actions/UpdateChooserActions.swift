//
//  UpdateChooserActions.swift
//  Patched Sur
//
//  Created by Ben Sova on 4/9/21.
//

import SwiftUI
import Files

func mergeNoDuplicate(a ar: [InstallAssistant], b: [InstallAssistant]) -> [InstallAssistant] {
    var a = ar
    let aV = a.map { $0.version }
    a.append(contentsOf: b.filter { !(aV.contains($0.version)) })
    return a
}

func fetchInstallerList(track: ReleaseTrack, fetchedInstallers: (InstallAssistants) -> (), current: (InstallAssistant) -> (), errorL: @escaping (String) -> ()) {
    print("Checking for pre-downloaded installer...")
    if (try? call("[[ -e ~/.patched-sur/InstallAssistant.pkg ]]")) != nil && ((try? call("[[ -e ~/.patched-sur/InstallInfo.txt ]]")) != nil) {
        print("Verifying pre-downloaded installer...")
        var alertX: Alert?
        guard let installerPath = (try? File(path: "~/.patched-sur/InstallAssistant.pkg"))?.path else { print("Unable to pull installer path"); return }
        if verifyInstaller(alert: &alertX, path: installerPath), let contents = try? File(path: "~/.patched-sur/InstallInfo.txt").readAsString() {
            print("Phrasing installer data...")
            guard let baseInfo = try? InstallAssistant(contents) else { return }
            current(InstallAssistant(url: installerPath, date: baseInfo.date, buildNumber: baseInfo.buildNumber, version: baseInfo.version, minVersion: 0, orderNumber: 0, notes: nil))
        }
    }
    let thingV = fetchInstallers(errorX: errorL, track: track)
    fetchedInstallers(thingV)
    if track != .release {
        let publicV = fetchInstallers(errorX: {_ in}, track: .release)
        fetchedInstallers(mergeNoDuplicate(a: thingV, b: publicV))
    }
}

func convertVersionBinary(_ version: String) -> Int {
    let vSections = version.split(separator: " ")
    let vParts = vSections[0].split(separator: ".")
    if vParts.count == 0 {
        return 114
    } else if vParts.count == 1 {
        return (Int(String(vParts[0]))! * 100)
    } else if vParts.count == 2 {
        return (Int(String(vParts[0]))! * 100) + (Int(String(vParts[1]))! * 10)
    } else if vParts.count == 3 {
        return (Int(String(vParts[0]))! * 100) + (Int(String(vParts[1]))! * 10) + (Int(String(vParts[2]))! * 1)
    } else {
        return 114
    }
}
