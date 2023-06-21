//
//  ExpressDetection.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/20/23.
//

import Foundation
import OSLog

struct ProblemInfo {
    let title, description: String
}

// MARK: - Check Compatability

func verifyCompat(barProgress: (CGFloat) -> (), problems: (ProblemInfo) -> ()) {
    
    var hasProblem = false
    
    // MARK: BigMac Check
    
    OSLog.verification.log("Checking if this is a Mac Pro...")
    
    if let macModel = try? call("sysctl -n hw.model"), macModel.contains("MacPro") {
        problems(ProblemInfo(title: .init("PROB-PRO-TITLE"), description: .init("PROB-PRO-DESCRIPTION")))
        OSLog.verification.log("This appeares to be a Mac Pro which is not supported.", type: .fault)
        hasProblem = true
    }
    
    barProgress(0.15)
    
    // MARK: FileVault Check
    
    OSLog.verification.log("Checking if FileVault is on...")
    
    if let fileVault = try? call("fdesetup status"), fileVault.contains("FileVault is On.") {
        if (try? call("sw_vers -productVersion | grep 11")) != nil {
            problems(ProblemInfo(title: .init("PROB-FILE-TITLE"), description: .init("PROB-FILE-DESCRIPTION")))
            OSLog.verification.log("FireVault appears to be on which is not supported.", type: .error)
            hasProblem = true
        } else {
            OSLog.verification.log("FireVault seems to be enabled, but this is macOS Big Sur so ignoring.", type: .fault)
        }
    }
    
    barProgress(0.3)
    
    // MARK: Metal Check
    
    OSLog.verification.log("Checking for Metal...")
    
    if let metalStatus = try? call("system_profiler SPDisplaysDataType | grep Metal"), !metalStatus.contains(": Supported") { //, !metalStatus.contains(": Metal 3")  {
        problems(ProblemInfo(title: .init("PROB-GX-TITLE"), description: .init("PROB-GX-DESCRIPTION")))
        OSLog.verification.log("This Mac does not support metal, and Patched Sur has no patch for that.", type: .fault)
        hasProblem = true
    }
    
    barProgress(0.45)
    
}
