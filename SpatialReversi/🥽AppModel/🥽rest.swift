import SwiftUI

extension 🥽AppModel {
    var showEntrance: Bool {
#if targetEnvironment(simulator)
        true
//        false
#else
        self.groupSession == nil
#endif
    }
    func reset() {
        withAnimation {
            self.activityState.pieces = .empty
            self.activityState.viewHeight = .default
            if self.groupSession != nil {
                self.activityState.mode = .sharePlay
            }
            self.playSound(.reset)
            self.sync()
        } completion: {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(1))
                self.applyPreset()
            }
        }
    }
    func raiseBoard() {
        self.activityState.viewHeight.value += 0.1
        self.sync()
    }
    func lowerBoard() {
        self.activityState.viewHeight.value -= 0.1
        self.sync()
    }
    func playSound(_ file: SoundFile) {
        self.soundFeedback.play(file)
        Task {
            try? await self.messenger?.send(👤PlaySound(file: file))
        }
    }
    var showResult: Bool {
        self.activityState.pieces.isFinished
    }
}
