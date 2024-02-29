import SwiftUI
import GroupActivities

extension 🥽AppModel {
    func activateGroupActivity() {
        Task {
            do {
                self.activityState.pieces = .default
                self.activityState.mode = .sharePlay
                let result = try await 👤GroupActivity().activate()
                switch result {
                    case true:
                        try? await Task.sleep(for: .seconds(1.5))
                        self.applyPreset()
                    case false:
                        self.activityState.mode = .localOnly
                }
            } catch {
                print("Failed to activate activity: \(error)")
                self.activityState.mode = .localOnly
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
                            self.activityState.pieces = .default
                            self.activityState.viewHeight = .default
                            self.activityState.mode = .localOnly
                        }
                    }
                    .store(in: &self.subscriptions)
                
                groupSession.$activeParticipants
                    .sink {
                        let newParticipants = $0.subtracting(groupSession.activeParticipants)
                        Task { @MainActor in
                            try? await messenger.send(👤Message(activityState: self.activityState,
                                                                pieceAnimation: .default()),
                                                      to: .only(newParticipants))
                        }
                    }
                    .store(in: &self.subscriptions)
                
                self.tasks.insert(
                    Task {
                        for await (message, _) in messenger.messages(of: 👤Message.self) {
                            Task { @MainActor in
                                withAnimation(message.pieceAnimation.value) {
                                    self.activityState = message.activityState
                                }
                            }
                        }
                    }
                )
                
                self.tasks.insert(
                    Task {
                        for await (message, _) in messenger.messages(of: 👤PlaySound.self) {
                            Task { @MainActor in
                                self.soundFeedback.play(message.file)
                            }
                        }
                    }
                )
                
#if os(visionOS)
                self.tasks.insert(
                    Task { @MainActor in
                        if let systemCoordinator = await groupSession.systemCoordinator {
                            for await localParticipantState in systemCoordinator.localParticipantStates {
                                self.isSpatial = localParticipantState.isSpatial
                            }
                        }
                    }
                )
                
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
    func sync(animation: 👤Message.PieceAnimation = .default()) {
        Task {
            try? await self.messenger?.send(👤Message(activityState: self.activityState,
                                                      pieceAnimation: animation))
        }
    }
}
