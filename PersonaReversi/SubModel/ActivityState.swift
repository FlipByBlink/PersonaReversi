struct ActivityState: Codable, Equatable {
    var pieces: Pieces = .default
    var viewHeight: ViewHeight = .default
    var mode: Mode = .localOnly
}
