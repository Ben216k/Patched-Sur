//
//  Transitions.swift
//  Patched Sur
//
//  Created by Ben Sova on 6/19/23.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var moveAway: AnyTransition {
        return .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
    }
    static var moveAway2: AnyTransition {
        return AnyTransition.asymmetric(insertion: AnyTransition.modifier(active: InsertItem(a: false), identity: InsertItem(a: true)), removal: AnyTransition.modifier(active: DeleteItem(a: false), identity: DeleteItem(a: true)))
    }
}

struct InsertItem: ViewModifier {
    let a: Bool
    func body(content: Content) -> some View {
        content
            .offset(x: a ? 0 : 200, y: 0)
            .opacity(a ? 1 : 0)
    }
}

struct DeleteItem: ViewModifier {
    let a: Bool
    func body(content: Content) -> some View {
        content
            .offset(x: a ? 0 : -100, y: 0)
            .opacity(a ? 1 : 0)
    }
}
