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
        self.viewHeight.value += 50
        self.sendViewHeight()
    }
    func lowerBoard() {
        self.viewHeight.value -= 50
        self.sendViewHeight()
    }
}
