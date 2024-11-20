//
//  main.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 12/1/20.
//

import Foundation
import OSLog

// OSLog to Hello World
os_log("Starting Patched Sur (preinstall) v2.0.0...", log: OSLog.bootup, type: .info)

#if DEBUG
os_log("Running with DEBUG modifications", log: OSLog.bootup, type: .info)
#endif

os_log("Ensuring ~/.patched-sur exists.", log: OSLog.bootup, type: .info)
_ = try? call("mkdir ~/.patched-sur", at: ".")

os_log("Startup configuration not currently avaiable, all command line agruments ignored.", log: OSLog.bootup, type: .info)
AppDelegate.main()
