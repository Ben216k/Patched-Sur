//
//  SupportedMacs.swift
//  Patched Sur - For Catalina
//
//  Created by Ben Sova on 6/21/23.
//

import Foundation

struct SupportedMac {
    var short: String
    var name: String
}

let supportedMacs: [SupportedMac] = [
    // MARK: MacBook Air -
    .init(short: "MacBookAir5,1", name: "MacBook Air (11-inch, Mid 2012)"),
    .init(short: "MacBookAir5,2", name: "MacBook Air (13-inch, Mid 2012)"),
    
    // MARK: MacBook Pro -
    .init(short: "MacBookPro9,2", name: "MacBook Pro (13-inch, Mid 2012)"),
    .init(short: "MacBookPro9,1", name: "MacBook Pro (15-inch, Mid 2012)"),
    .init(short: "MacBookPro10,2", name: "MacBook Pro (Retina, 13-inch, Mid 2012)"),
    .init(short: "MacBookPro10,1", name: "MacBook Pro (Retina, 15-inch, Mid 2012)"),
    
    // MARK: Mac Mini -
    .init(short: "Macmini6,1", name: "Mac Mini (Late 2012)"),
    .init(short: "Macmini6,2", name: "Mac Mini Server (Late 2012)"),
    
    // MARK: iMac -
    .init(short: "iMac13,1", name: "iMac (21.5-inch, Late 2012)"),
    .init(short: "iMac13,2", name: "iMac (27-inch, Late 2012)"),
    .init(short: "iMac14,1", name: "iMac (21.5-inch, Late 2013)"),
    .init(short: "iMac14,2", name: "iMac (27-inch, Late 2013)"),
]
