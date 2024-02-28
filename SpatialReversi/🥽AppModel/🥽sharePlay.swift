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
                        Task { @MainActor in
                            if let pieces = self.pieces,
                               let viewHeight = self.viewHeight {
                                try? await messenger.send(👤ActivityState(pieces: pieces,
                                                                          pieceAnimation: .default(),
                                                                          viewHeight: viewHeight),
                                                          to: .only(newParticipants))
                            }
                        }
                    }
                    .store(in: &self.subscriptions)
                
                self.tasks.insert(
                    Task {
                        for await (message, _) in messenger.messages(of: 👤ActivityState.self) {
                            Task { @MainActor in
                                withAnimation(message.pieceAnimation.value) {
                                    self.pieces = message.pieces
                                    self.viewHeight = message.viewHeight
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
    func send(pieceAnimation: 👤ActivityState.PieceAnimation = .default()) {
        Task {
            if let pieces = self.pieces,
               let viewHeight = self.viewHeight {
                try? await self.messenger?.send(👤ActivityState(pieces: pieces,
                                                                pieceAnimation: pieceAnimation,
                                                                viewHeight: viewHeight))
            }
        }
    }
}
