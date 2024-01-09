import SwiftUI

struct Piece {
    var side: Side
    var phase: Self.Phase
}

extension Piece {
    enum Phase {
        case clear, fadeIn, slideDown, complete, slideUp, flip
    }
    var angle: Angle {
        .degrees(self.side == .black ? 180 : 0)
    }
    var zOffset: Double {
        [.clear, .fadeIn, .slideUp, .flip].contains(self.phase) ? 70 : 0
    }
    var opacity: Double {
        self.phase == .clear ? 0 : 1
    }
}
