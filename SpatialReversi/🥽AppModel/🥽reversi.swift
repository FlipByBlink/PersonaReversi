import SwiftUI

extension 🥽AppModel {
    func set(_ index: Int) {
        if self.pieces[index] == nil {
            withAnimation(.default.speed(2)) {
                self.pieces.set(index, self.side)
                self.send(animate: .default(speed: 2))
            } completion: {
                withAnimation(.default.speed(1.6)) {
                    self.pieces.changePhase(index, .fadeIn)
                    self.send(animate: .default(speed: 1.6))
                } completion: {
                    withAnimation {
                        self.pieces.changePhase(index, .slideDown)
                        self.send(playingSound: true)
                    } completion: {
                        self.soundFeedback.execute()
                        self.pieces.affected(index).forEach { self.toggle($0) }
                        self.send()
                        self.handleResultView()
                    }
                }
            }
        }
    }
    func toggle(_ index: Int) {
        withAnimation {
            self.pieces.changePhase(index, .slideUp)
            self.send()
        } completion: {
            withAnimation {
                self.pieces.toggle(index)
                self.send()
            } completion: {
                withAnimation {
                    self.pieces.changePhase(index, .slideDown)
                    self.send()
                }
            }
        }
    }
    func applyPreset() {
        for (index, piece) in Pieces.preset {
            withAnimation {
                self.pieces.set(index, piece.side)
                self.send()
            } completion: {
                withAnimation(.default.speed(2)) {
                    self.pieces.changePhase(index, .fadeIn)
                    self.send(animate: .default(speed: 2))
                } completion: {
                    withAnimation {
                        self.pieces.changePhase(index, .slideDown)
                        self.send()
                    }
                }
            }
        }
    }
    func reset() {
        withAnimation {
            self.presentResult = false
            self.pieces = .empty
            self.send()
        } completion: {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                self.applyPreset()
            }
        }
    }
    func handleResultView() {
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            if self.pieces.isMax {
                withAnimation {
                    self.presentResult = true
                }
            }
        }
    }
}
