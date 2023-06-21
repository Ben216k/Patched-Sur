//
//  InstallAssistantActions.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import Foundation

func fetchInstallers(errorX: (String) -> ()) -> [InstallAssistant] {
    do {
        print("Fetching installers from 'https://ben216k.github.io/patched-sur/Release.json'")
//        var installers = try [InstallAssistant](fromURL: "https://ben216k.github.io/patched-sur/Release.json")
        var installers = try JSONDecoder().decode([InstallAssistant].self, from: .init(contentsOf: URL(string: "https://ben216k.github.io/patched-sur/Release.json")!))
        print("Fetched: \(installers.map { $0.version })")
        print("Filtering installer list for compatible versions")
        installers = installers.filter { $0.minVersion <= AppInfo.build }
        print("Sorting installer list")
        installers.reverse()
        print("Verifying there are compatible installers")
        if installers.count > 0 {
            print("Passing back installers")
            return installers
        } else {
            print("Installer list has no values, this patcher version must have been discontinued.")
            errorX("This version of Patched Sur has been discontinued.\nPlease use the latest version of the patcher.")
            return []
        }
    } catch {
        print("InstallAssistant fetch failed.")
        errorX(error.localizedDescription)
        return []
    }
}
