import SwiftUI

class AppModel: ObservableObject {
    @Published var pieces: Pieces = .init()
    @Published var side: Side = .white
}

extension AppModel {
    func set(_ index: Int) {
        if self.pieces[index] == nil {
            withAnimation(.default.speed(2)) {
                self.pieces.set(index, self.side)
            } completion: {
                withAnimation(.default.speed(1.6)) {
                    self.pieces.changePhase(index, .fadeIn)
                } completion: {
                    withAnimation {
                        self.pieces.changePhase(index, .slideDown)
                    } completion: {
                        for direction in [-9, -8, -7, -1, 1, 7, 8, 9] {
                            var counts: Int = 0
                            while counts < 8 {
                                if let piece = self.pieces[index + (direction * (counts + 1))] {
                                    if piece.side == self.side {
                                        if counts > 0 {
                                            (1...counts).forEach {
                                                self.toggle(index + direction * $0)
                                            }
                                        }
                                        break
                                    } else {
                                        counts += 1
                                    }
                                } else {
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func toggle(_ index: Int) {
        withAnimation {
            self.pieces.changePhase(index, .slideUp)
        } completion: {
            withAnimation {
                self.pieces.toggle(index)
            } completion: {
                withAnimation {
                    self.pieces.changePhase(index, .slideDown)
                }
            }
        }
    }
    func applyPreset() {
        for (index, piece) in Pieces.preset {
            withAnimation {
                self.pieces.set(index, piece.side)
            } completion: {
                withAnimation(.default.speed(2)) {
                    self.pieces.changePhase(index, .fadeIn)
                } completion: {
                    withAnimation {
                        self.pieces.changePhase(index, .slideDown)
                    }
                }
            }
        }
    }
    func reset() {
        withAnimation {
            self.pieces = .init()
        } completion: {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                self.applyPreset()
            }
        }
    }
}
