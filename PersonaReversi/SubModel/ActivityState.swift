struct ActivityState: Codable, Equatable {
    var pieces: Pieces = .default
    var viewHeight: ViewHeight = .default
    var showResult: Bool = false
    var mode: Mode = .localOnly
}
