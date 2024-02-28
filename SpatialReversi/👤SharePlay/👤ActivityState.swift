import SwiftUI

struct 👤ActivityState: Codable {
    var pieces: Pieces
    var pieceAnimation: Self.PieceAnimation
    var viewHeight: ViewHeight
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
