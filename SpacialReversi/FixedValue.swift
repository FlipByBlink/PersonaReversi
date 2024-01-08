import Foundation

enum FixedValue {
    static let windowLength: CGFloat = 1200.0
    static let toolbarHeight: CGFloat = 100.0
    static let presetPieces: [Int: Piece] = {
        [28: .init(side: .black, zOffset: 0, opacity: 1),
         29: .init(side: .white, zOffset: 0, opacity: 1),
         36: .init(side: .white, zOffset: 0, opacity: 1),
         37: .init(side: .black, zOffset: 0, opacity: 1)]
    }()
}
