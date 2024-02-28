import SwiftUI
import GroupActivities

extension 🥽AppModel {
    func activateGroupActivity() {
        Task {
            do {
                self.pieces = .empty
                self.viewHeight = .default
                let result = try await 👤GroupActivity().activate()
                switch result {
                    case true:
                        try? await Task.sleep(for: .seconds(0.5))
                        self.applyPreset()
                    case false:
                        self.pieces = nil
                        self.viewHeight = nil
                }
            } catch {
                print("Failed to activate activity: \(error)")
                self.pieces = nil
                self.viewHeight = nil
            }
        }
    }
    func configureGroupSessions() {
        Task {
            for await groupSession in 👤GroupActivity.sessions() {
                self.groupSession = groupSession
                let messenger = GroupSessionMessenger(session: groupSession)
                self.messenger = messenger
                
                groupSession.$state
                    .sink {
                        if case .invalidated = $0 {
                            self.messenger = nil
                            self.tasks.forEach { $0.cancel() }
                            self.tasks = []
                            self.subscriptions = []
                            self.groupSession = nil
                            self.isSpatial = nil
                            self.pieces = nil
                            self.viewHeight = nil
                        }
                    }
                    .store(in: &self.subscriptions)
                
                groupSession.$activeParticipants
                    .sink {
                        let newParticipants = $0.subtracting(groupSession.activeParticipants)
                        Task {
                            if let pieces = self.pieces {
                                try? await messenger.send(👤Message(pieces: pieces,
                                                                    animate: .default(),
                                                                    playingSound: false),
                                                          to: .only(newParticipants))
                            }
                            if let viewHeight = self.viewHeight {
                                try? await messenger.send(viewHeight)
                            }
                        }
                    }
                    .store(in: &self.subscriptions)
                
                self.tasks.insert(
                    Task {
                        for await (message, _) in messenger.messages(of: 👤Message.self) {
                            Task { @MainActor in
                                withAnimation(message.animate.value) {
                                    self.pieces = message.pieces
                                } completion: {
                                    if message.playingSound {
                                        self.soundFeedback.execute()
                                    }
                                }
                            }
                        }
                    }
                )
                
                self.tasks.insert(
                    Task {
                        for await (message, _) in messenger.messages(of: ViewHeight.self) {
                            Task { @MainActor in
                                withAnimation {
                                    self.viewHeight = message
                                }
                            }
                        }
                    }
                )
                
#if os(visionOS)
                self.tasks.insert(
                    Task {
                        if let systemCoordinator = await groupSession.systemCoordinator {
                            for await localParticipantState in systemCoordinator.localParticipantStates {
                                self.isSpatial = localParticipantState.isSpatial
                            }
                        }
                    }
                )
                
                //Task {
                //    if let systemCoordinator = await groupSession.systemCoordinator {
                //        for await immersionStyle in systemCoordinator.groupImmersionStyle {
                //            if let immersionStyle {
                //                // Open an immersive space with the same immersion style
                //            } else {
                //                // Dismiss the immersive space
                //            }
                //        }
                //    }
                //}
                
                Task {
                    if let systemCoordinator = await groupSession.systemCoordinator {
                        var configuration = SystemCoordinator.Configuration()
                        configuration.supportsGroupImmersiveSpace = true
                        systemCoordinator.configuration = configuration
                        groupSession.join()
                    }
                }
#elseif os(iOS)
                groupSession.join()
#endif
            }
        }
    }
    func send(animate: 👤Message.Animate = .default(), playingSound: Bool = false) {
        Task {
            if let pieces = self.pieces {
                try? await self.messenger?.send(👤Message(pieces: pieces,
                                                          animate: animate,
                                                          playingSound: playingSound))
            }
        }
    }
    func sendViewHeight() {
        Task {
            if let viewHeight = self.viewHeight {
                try? await self.messenger?.send(viewHeight)
            }
        }
    }
}
