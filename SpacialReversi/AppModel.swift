import SwiftUI

class AppModel: ObservableObject {
    @Published var pieces: Pieces = .init()
    @Published var side: Side = .white
}

extension AppModel {
    func set(_ index: Int) {
        if self.pieces[index] == nil {
            self.pieces.set(index, self.side)
            withAnimation(.default.speed(2)) {
                self.pieces.changePhase(index, .fadeIn)
            } completion: {
                withAnimation {
                    self.pieces.changePhase(index, .slideDown)
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
            self.pieces.changePhase(index, .slideUp)
        } completion: {
            withAnimation {
                self.pieces.toggle(index)
            } completion: {
                withAnimation {
                    self.pieces.changePhase(index, .slideDown)
                }
            }
        }
    }
}

struct Pieces {
    private var value: [Int: Piece] = Self.preset
    subscript(_ index: Int) -> Piece? {
        self.value[index]
    }
    mutating func set(_ index: Int, _ side: Side) {
        self.value[index] = .init(side: side, phase: .clear)
    }
    mutating func changePhase(_ index: Int, _ phase: Piece.Phase) {
        self.value[index]?.phase = phase
    }
    mutating func toggle(_ index: Int) {
        self.value[index]?.side.toggle()
    }
    static let preset: [Int: Piece] = {
        [28: .init(side: .black, phase: .complete),
         29: .init(side: .white, phase: .complete),
         36: .init(side: .white, phase: .complete),
         37: .init(side: .black, phase: .complete)]
    }()
}

struct Piece {
    var side: Side
    var phase: Phase
    enum Phase {
        case clear, fadeIn, slideDown, complete, slideUp, flip
    }
    var angle: Angle { .degrees(self.side == .black ? 180 : 0) }
    var zOffset: Double {
        [.clear, .fadeIn, .slideUp, .flip].contains(self.phase) ? 70 : 0
    }
    var opacity: Double {
        self.phase == .clear ? 0 : 1
    }
}
