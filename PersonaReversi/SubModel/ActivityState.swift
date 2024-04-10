struct ActivityState: Codable, Equatable {
    var pieces: Pieces = .default
    var showResult: Bool = false
    var mode: Mode = .localOnly
}
