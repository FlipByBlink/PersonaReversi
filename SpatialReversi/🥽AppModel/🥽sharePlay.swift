import SwiftUI
import GroupActivities

extension 🥽AppModel {
    func activateGroupActivity() {
        Task {
            do {
                _ = try await 👤GroupActivity().activate()
            } catch {
                print("Failed to activate activity: \(error)")
            }
        }
    }
    func configureGroupSessions() async {
        for await groupSession in 👤GroupActivity.sessions() {
            self.reset()
            
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
                        self.reset()
                    }
                }
                .store(in: &self.subscriptions)
            
            groupSession.$activeParticipants
                .sink {
                    let newParticipants = $0.subtracting(groupSession.activeParticipants)
                    Task {
                        try? await messenger.send(👤Message(pieces: self.pieces,
                                                            animate: .default(),
                                                            playingSound: false),
                                                  to: .only(newParticipants))
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
                                    self.soundEffect.execute()
                                }
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
    func send(animate: 👤Message.Animate = .default(), playingSound: Bool = false) {
        Task {
            try? await self.messenger?.send(👤Message(pieces: self.pieces,
                                                      animate: animate,
                                                      playingSound: playingSound))
        }
    }
}
