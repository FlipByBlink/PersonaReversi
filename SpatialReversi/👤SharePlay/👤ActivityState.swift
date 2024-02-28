import SwiftUI

struct 👤ActivityState: Codable {
    let pieces: Pieces
    let pieceAnimation: Self.PieceAnimation
    let viewHeight: ViewHeight
}

extension 👤ActivityState {
    enum PieceAnimation: Codable {
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
