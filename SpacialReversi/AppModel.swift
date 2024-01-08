import SwiftUI

class AppModel: ObservableObject {
    @Published var pieces: [Int: Side] = [28: .black, 29: .white,
                                          36: .white, 37: .black]
    @Published var side: Side = .white
}

extension AppModel {
    func set(_ index: Int) {
        if self.pieces[index] == nil {
            self.pieces[index] = self.side
            for direction in [-9, -8, -7, -1, 1, 7, 8, 9] {
                if let piece = self.pieces[index - direction],
                   piece != self.side,
                   let piece2 = self.pieces[index - direction * 2],
                   piece2 == self.side {
                    self.pieces[index - direction] = self.side
                }
            }
        }
    }
}
