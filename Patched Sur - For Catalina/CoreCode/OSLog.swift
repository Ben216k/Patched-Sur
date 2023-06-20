//
//  OSLog.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/19/23.
//

import Foundation
import OSLog

extension OSLog {
    private static var subsystem = "me.ben216k.Patched-Sur.catalina"

    /// Logs in the bootup of the app when preparing for everything.
    static let bootup = OSLog(subsystem: subsystem, category: "bootup")
    
}
