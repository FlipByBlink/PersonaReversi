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
    static let preset: [Int: Piece] = {
        [28: .init(side: .black, phase: .complete),
         29: .init(side: .white, phase: .complete),
         36: .init(side: .white, phase: .complete),
         37: .init(side: .black, phase: .complete)]
    }()
}
