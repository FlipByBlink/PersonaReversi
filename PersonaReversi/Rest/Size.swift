import Foundation

enum Size {
    static let board: CGFloat = 1200
    static let boardPadding: CGFloat = 96
    static var square: CGFloat { (Self.board - (Self.boardPadding * 2)) / 8 }
    static let toolbarHeight: CGFloat = 100
    static var toolbarOffset: CGFloat { (Self.board / 2) + 16 }
    static let windowMargin: CGFloat = 48
    static var window: CGFloat { Self.board + Self.boardPadding * 2 + Self.windowMargin * 2 }
}
