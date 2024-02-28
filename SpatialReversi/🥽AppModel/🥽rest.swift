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
