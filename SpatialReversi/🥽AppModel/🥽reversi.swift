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
                        let affectedIndexes = self.pieces.affected(index)
                        if affectedIndexes.count > 0 {
                            withAnimation {
                                affectedIndexes.forEach {
                                    self.pieces.changePhase($0, .slideUp)
                                }
                                self.send()
                            } completion: {
                                withAnimation {
                                    affectedIndexes.forEach {
                                        self.pieces.toggle($0)
                                    }
                                    self.send()
                                } completion: {
                                    withAnimation {
                                        affectedIndexes.forEach {
                                            self.pieces.changePhase($0, .slideDown)
                                        }
                                        self.send()
                                        self.handleResultView()
                                    }
                                }
                            }
                        } else {
                            self.handleResultView()
                        }
                    }
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
            } else {
                self.presentResult = false
            }
        }
    }
}
