import SwiftUI

extension 🥽AppModel {
    func setPiecesForDebug() {
#if DEBUG
        Task { @MainActor in
            let indexes = (1...64).filter { ![28, 29, 36, 37, 59, 62, 63].contains($0) }
            indexes.forEach {
                self.activityState.pieces.set($0, Bool.random() ? .black : .white)
            }
            indexes.forEach {
                self.activityState.pieces.changePhase($0, .complete)
            }
            self.sync()
        }
#endif
    }
}
