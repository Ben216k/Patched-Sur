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
    case hv12vOld = "hv12v-old"
    case hv12vNew = "hv12v-new"
    
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

enum PSSNBKext: String {
    case none = "Disabled"
    case bundle = "Bundle"
    case kext = "Kext"
    
    mutating func toggle() {
        if self == .none {
            self = .bundle
        } else if self == .bundle {
            self = .kext
        } else if self == .kext {
            self = .none
        }
    }
}
