//
//  OSLog.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/19/23.
//

import Foundation
import OSLog

extension OSLog {
    static var subsystem = "me.ben216k.Patched-Sur.catalina"
    
    func log(_ string: StaticString, type: OSLogType = .info) {
        os_log(string, log: self, type: type)
    }
}
