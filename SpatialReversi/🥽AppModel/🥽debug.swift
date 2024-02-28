import SwiftUI

extension 🥽AppModel {
    func setUpForDebug() {
#if DEBUG
        Task {
            self.pieces = .empty
            self.viewHeight = .default
            try? await Task.sleep(for: .seconds(0.5))
            self.applyPreset()
        }
#endif
    }
    func setPiecesForDebug() {
#if DEBUG
        Task { @MainActor in
            let indexes = (1...64).filter { ![28, 29, 36, 37, 62, 63].contains($0) }
            indexes.forEach {
                self.pieces?.set($0, Bool.random() ? .black : .white)
            }
            indexes.forEach {
                self.pieces?.changePhase($0, .complete)
            }
            self.sync()
        }
#endif
    }
}
