import SwiftUI

struct Piece {
    var side: Side
    var phase: Self.Phase
}

extension Piece: Codable, Equatable {
    enum Phase: Codable {
        case clear,
             fadeIn,
             slideDown,
             complete,
             slideUp,
             flip
    }
    var angle: Angle {
        .degrees(self.side == .black ? 180 : 0)
    }
    var zOffset: Double {
        switch self.phase {
            case .clear, .fadeIn: 70
            case .slideUp, .flip: 50
            default: 0
        }
    }
    var opacity: Double {
        self.phase == .clear ? 0 : 1
    }
}
