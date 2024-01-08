import SwiftUI

class AppModel: ObservableObject {
    @Published var pieces: [Int: Side] = [28: .black, 29: .white,
                                          36: .white, 37: .black]
    @Published var side: Side = .white
}

extension AppModel {
    func set(_ index: Int) {
        self.pieces[index] = self.side
    }
}
