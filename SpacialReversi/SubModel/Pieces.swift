struct Pieces {
    private var value: [Int: Piece] = [:]
}

extension Pieces {
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
    var pieceCounts: [Side: Int] {
        self.value.reduce(into: [:]) {
            if let count = $0[$1.value.side] {
                $0[$1.value.side] = count + 1
            } else {
                $0[$1.value.side] = 1
            }
        }
    }
    var isMax: Bool {
        self.value.count == 64
    }
    static let preset: [Int: Piece] = {
        [28: .init(side: .black, phase: .complete),
         29: .init(side: .white, phase: .complete),
         36: .init(side: .white, phase: .complete),
         37: .init(side: .black, phase: .complete)]
    }()
}
