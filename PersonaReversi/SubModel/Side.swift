enum Side {
    case white,
         black
}

extension Side: Codable {
    mutating func toggle() {
        switch self {
            case .white: self = .black
            case .black: self = .white
        }
    }
}
