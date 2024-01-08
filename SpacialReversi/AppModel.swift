import SwiftUI

class AppModel: ObservableObject {
    @Published var pieces: [Int: Piece] = FixedValue.presetPieces
    @Published var side: Side = .white
}

extension AppModel {
    func set(_ index: Int) {
        if self.pieces[index] == nil {
            self.pieces[index] = .init(side: self.side)
            withAnimation(.default.speed(2)) {
                self.pieces[index]?.opacity = 1
            } completion: {
                withAnimation {
                    self.pieces[index]?.zOffset = 0
                } completion: {
                    for direction in [-9, -8, -7, -1, 1, 7, 8, 9] {
                        var counts: Int = 0
                        while counts < 8 {
                            if let piece = self.pieces[index + (direction * (counts + 1))] {
                                if piece.side == self.side {
                                    if counts > 0 {
                                        (1...counts).forEach {
                                            self.toggle(index + direction * $0)
                                        }
                                    }
                                    break
                                } else {
                                    counts += 1
                                }
                            } else {
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    func toggle(_ index: Int) {
        withAnimation {
            self.pieces[index]?.zOffset = 70
        } completion: {
            withAnimation {
                self.pieces[index]?.side.toggle()
            } completion: {
                withAnimation {
                    self.pieces[index]?.zOffset = 0
                }
            }
        }
    }
}

struct Piece {
    var side: Side
    var zOffset: Double = 70
    var opacity: Double = 0
    var degrees: Double {
        switch self.side {
            case .black: 180
            case .white: 0
        }
    }
}
