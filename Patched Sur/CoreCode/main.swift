//
//  main.swift
//  Patched Sur
//
//  Created by Benjamin Sova on 11/29/20.
//

import Foundation
import OSLog

os_log("Starting Patched Sur (main) v2.0.0...", log: OSLog.bootup, type: .info)

#if DEBUG
os_log("Running with DEBUG modifications", log: OSLog.bootup, type: .info)
#endif

os_log("Startup configuration not currently avaiable, all command line agruments ignored.", log: OSLog.bootup, type: .info)

PatchedSurApp.main()
