import SwiftUI

extension 🥽AppModel {
    var showEntrance: Bool {
#if targetEnvironment(simulator)
        !true
#else
        self.groupSession == nil
#endif
    }
    var showReversi: Bool {
        !self.showEntrance
    }
    func reset() {
        withAnimation {
            self.pieces = .empty
            self.viewHeight = .default
            self.send()
        } completion: {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                self.applyPreset()
            }
        }
    }
    func raiseBoard() {
        if let value = self.viewHeight?.value {
            self.viewHeight?.value = value + 50
            self.sendViewHeight()
        }
    }
    func lowerBoard() {
        if let value = self.viewHeight?.value {
            self.viewHeight?.value = value - 50
            self.sendViewHeight()
        }
    }
}
