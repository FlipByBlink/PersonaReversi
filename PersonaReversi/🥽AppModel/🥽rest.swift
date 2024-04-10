import SwiftUI

extension 🥽AppModel {
    func reset() {
        withAnimation {
            self.activityState.pieces = .empty
            self.activityState.showResult = false
            if self.groupSession != nil {
                self.activityState.mode = .sharePlay
            }
            self.playSound(.reset)
            self.sync()
        } completion: {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.45))
                self.applyPreset()
            }
        }
    }
    func playSound(_ file: SoundFile) {
        self.soundFeedback.play(file)
        Task {
            try? await self.messenger?.send(👤PlaySound(file: file))
        }
    }
}
