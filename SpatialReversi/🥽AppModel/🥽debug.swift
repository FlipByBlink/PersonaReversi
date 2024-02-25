import Foundation

extension 🥽AppModel {
    func setPiecesForDebug() {
#if DEBUG
        Task { @MainActor in
            for index in (1...64) {
                if ![28, 29, 36, 37, 63].contains(index) {
                    try? await Task.sleep(for: .seconds(0.2))
                    self.set(index)
                    self.side = Bool.random() ? .black : .white
                }
            }
        }
#endif
    }
}
