import SwiftUI

struct 👤Message {
    var pieces: Pieces
    var animate: Self.Animate
    var playingSound: Bool
}

extension 👤Message: Codable {}

extension 👤Message {
    enum Animate: Codable {
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
