import SwiftUI

struct 👤Message: Codable, Equatable {
    let activityState: ActivityState
    let pieceAnimation: Self.PieceAnimation
}

extension 👤Message {
    enum PieceAnimation: Codable, Equatable {
        case none
        case `default`(speed: Double = 1)
        var value: Animation? {
            switch self {
                case .none: nil
                case .default(let speed): .default.speed(speed)
            }
        }
    }
}
