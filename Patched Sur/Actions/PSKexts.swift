//
//  PSKexts.swift
//  Patched Sur
//
//  Created by Ben Sova on 5/13/21.
//

import Foundation

enum PSWiFiKext: String {
    case none = "Disabled"
    case mojaveHybrid = "Mojave-Hybrid"
    case hv12vOld = "highvoltage12v (Old)"
    case hv12vNew = "highvoltage12v (New)"
    
    mutating func toggle() {
        if self == .mojaveHybrid {
            self = .hv12vNew
        } else if self == .hv12vNew {
            self = .hv12vOld
        } else if self == .hv12vOld {
            self = .none
        } else if self == .none {
            self = .mojaveHybrid
        }
    }
}
