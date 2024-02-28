import SwiftUI

extension 🥽AppModel {
    func set(_ index: Int) {
        if self.pieces?[index] == nil {
            withAnimation(.default.speed(2)) {
                self.pieces?.set(index, self.side)
                self.sync(animation: .default(speed: 2))
            } completion: {
                withAnimation(.default.speed(1.6)) {
                    self.pieces?.changePhase(index, .fadeIn)
                    self.sync(animation: .default(speed: 1.6))
                } completion: {
                    withAnimation {
                        self.pieces?.changePhase(index, .slideDown)
                        self.sync()
                    } completion: {
                        self.playSound(.crack)
                        let affectedIndexes = self.pieces?.affected(index) ?? []
                        if affectedIndexes.count > 0 {
                            withAnimation {
                                affectedIndexes.forEach {
                                    self.pieces?.changePhase($0, .slideUp)
                                }
                                self.sync()
                            } completion: {
                                withAnimation {
                                    affectedIndexes.forEach {
                                        self.pieces?.toggle($0)
                                    }
                                    self.sync()
                                } completion: {
                                    withAnimation {
                                        affectedIndexes.forEach {
                                            self.pieces?.changePhase($0, .slideDown)
                                        }
                                        self.sync()
                                    } completion: {
                                        affectedIndexes.forEach {
                                            self.pieces?.changePhase($0, .complete)
                                        }
                                        self.pieces?.changePhase(index, .complete)
                                        self.sync()
                                    }
                                }
                            }
                        } else {
                            self.pieces?.changePhase(index, .complete)
                            self.sync()
                        }
                    }
                }
            }
        }
    }
    func applyPreset() {
        for (index, piece) in Pieces.preset {
            withAnimation {
                self.pieces?.set(index, piece.side)
                self.sync()
            } completion: {
                withAnimation(.default.speed(2)) {
                    self.pieces?.changePhase(index, .fadeIn)
                    self.sync(animation: .default(speed: 2))
                } completion: {
                    withAnimation {
                        self.pieces?.changePhase(index, .slideDown)
                        self.sync()
                    } completion: {
                        self.pieces?.changePhase(index, .complete)
                        self.sync()
                    }
                }
            }
        }
    }
    var showResult: Bool {
        self.pieces?.isFinished ?? false
    }
}
