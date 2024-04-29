//
//  OSLogUniversal.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/19/23.
//

import Foundation
import OSLog

extension OSLog {
    /// Logs in the bootup of the app when preparing for everything.
    static let bootup = OSLog(subsystem: subsystem, category: "bootup")
    static let ui = OSLog(subsystem: subsystem, category: "ui")
    static let verification = OSLog(subsystem: subsystem, category: "verification")
    static let downloads = OSLog(subsystem: subsystem, category: "downloads")
    
}
