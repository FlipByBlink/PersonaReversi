import SwiftUI

extension 🥽AppModel {
    func set(_ index: Int) {
        if self.activityState.pieces[index] == nil {
            withAnimation(.default.speed(2)) {
                self.activityState.pieces.set(index, self.side)
                self.sync(animation: .default(speed: 2))
            } completion: {
                withAnimation(.default.speed(1.6)) {
                    self.activityState.pieces.changePhase(index, .fadeIn)
                    self.sync(animation: .default(speed: 1.6))
                } completion: {
                    withAnimation {
                        self.activityState.pieces.changePhase(index, .slideDown)
                        self.sync()
                    } completion: {
                        self.playSound(.crack)
                        let affectedIndexes = self.activityState.pieces.effectivePieces(self.side, index)
                        if affectedIndexes.count > 0 {
                            withAnimation {
                                affectedIndexes.forEach {
                                    self.activityState.pieces.changePhase($0, .slideUp)
                                }
                                self.sync()
                            } completion: {
                                withAnimation {
                                    affectedIndexes.forEach {
                                        self.activityState.pieces.toggle($0)
                                    }
                                    self.sync()
                                } completion: {
                                    withAnimation {
                                        affectedIndexes.forEach {
                                            self.activityState.pieces.changePhase($0, .slideDown)
                                        }
                                        self.sync()
                                    } completion: {
                                        affectedIndexes.forEach {
                                            self.activityState.pieces.changePhase($0, .complete)
                                        }
                                        self.activityState.pieces.changePhase(index, .complete)
                                        if self.activityState.pieces.isFinished {
                                            self.activityState.showResult = true
                                        }
                                        self.sync()
                                    }
                                }
                            }
                        } else {
                            self.activityState.pieces.changePhase(index, .complete)
                            self.sync()
                        }
                    }
                }
            }
        }
    }
    func applyPreset() {
        withAnimation {
            Pieces.preset.forEach {
                self.activityState.pieces.set($0, $1.side)
            }
            self.sync()
        } completion: {
            withAnimation(.default.speed(2)) {
                Pieces.preset.keys.forEach {
                    self.activityState.pieces.changePhase($0, .fadeIn)
                }
                self.sync(animation: .default(speed: 2))
            } completion: {
                withAnimation {
                    Pieces.preset.keys.forEach {
                        self.activityState.pieces.changePhase($0, .slideDown)
                    }
                    self.sync()
                } completion: {
                    Pieces.preset.keys.forEach {
                        self.activityState.pieces.changePhase($0, .complete)
                    }
                    self.sync()
                }
            }
        }
    }
    func puttable(_ index: Int) -> Bool {
        self.activityState.pieces.puttable(self.side, index)
        &&
        (self.activityState.pieces.isMoving == false)
    }
}
