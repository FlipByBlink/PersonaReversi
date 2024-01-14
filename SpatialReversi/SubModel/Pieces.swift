struct Pieces {
    private var value: [Int: Piece] = [:]
}

extension Pieces: Codable {
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
    var shoudPlaySound: Bool {
        self.value.values.contains { $0.phase == .fadeIn }
    }
    func affected(_ centerIndex: Int) -> [Int] {
        var value: [Int] = []
        for direction in Self.Direction.allCases {
            var counts: Int = 0
            while counts < 8 {
                let checkingIndex = centerIndex + (direction.offset * (counts + 1))
                if let piece = self[checkingIndex] {
                    if piece.side == self[centerIndex]?.side {
                        if counts > 0 {
                            (1...counts).forEach {
                                value.append(centerIndex + direction.offset * $0)
                            }
                        }
                        break
                    } else {
                        if direction.isLast(checkingIndex) {
                            break
                        } else {
                            counts += 1
                        }
                    }
                } else {
                    break
                }
            }
        }
        return value
    }
    static let preset: [Int: Piece] = {
        [28: .init(side: .black, phase: .complete),
         29: .init(side: .white, phase: .complete),
         36: .init(side: .white, phase: .complete),
         37: .init(side: .black, phase: .complete)]
    }()
}

fileprivate extension Pieces {
    enum Direction: CaseIterable {
        case leftTop, top, rightTop,
             left, right,
             leftBottom, bottom, rightBottom
        var offset: Int {
            switch self {
                case .leftTop: -9
                case .top: -8
                case .rightTop: -7
                case .left: -1
                case .right: 1
                case .leftBottom: 7
                case .bottom: 8
                case .rightBottom: 9
            }
        }
        func isLast(_ checkingIndex: Int) -> Bool {
            switch self {
                case .leftTop, .rightTop, .leftBottom, .rightBottom:
                    checkingIndex <= 8
                    || checkingIndex % 8 == 1
                    || checkingIndex % 8 == 0
                    || 57 <= checkingIndex
                case .top, .bottom:
                    checkingIndex <= 8
                    || 57 <= checkingIndex
                case .left, .right:
                    checkingIndex % 8 == 1
                    || checkingIndex % 8 == 0
            }
        }
    }
}
