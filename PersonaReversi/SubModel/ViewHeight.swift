struct ViewHeight: Codable, Equatable {
    var value: Double //meters
    static let `default`: Self = .init(value: 0.8)
}
