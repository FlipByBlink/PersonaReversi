import SwiftUI
import GroupActivities

extension 🥽AppModel {
    func configureGroupSessions() {
        Task {
            for await groupSession in 👤GroupActivity.sessions() {
                self.activityState.pieces = .empty
                self.activityState.showResult = false
                self.activityState.mode = .localOnly
                self.playSound(.reset)
                
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
                            self.activityState.pieces = .default
                            self.activityState.showResult = false
                            self.activityState.mode = .localOnly
                        }
                    }
                    .store(in: &self.subscriptions)
                
                groupSession.$activeParticipants
                    .sink {
                        if $0.count == 1, self.activityState.pieces == .empty {
                            Task {
                                try? await Task.sleep(for: .seconds(0.45))
                                self.activityState.mode = .sharePlay
                                self.applyPreset()
                            }
                        }
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
                            guard message.activityState.mode == .sharePlay else { continue }
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
                
                groupSession.join()
            }
        }
    }
    func sync(animation: 👤Message.PieceAnimation = .default()) {
        Task {
            try? await self.messenger?.send(👤Message(activityState: self.activityState,
                                                      pieceAnimation: animation))
        }
    }
    func activateGroupActivity() {
        Task {
            do {
                let groupActivity = 👤GroupActivity()
                switch await groupActivity.prepareForActivation() {
                    case .activationPreferred:
                        let result = try await groupActivity.activate()
                        if result == false { throw Self.ActivationError.failed }
                    case .activationDisabled:
                        throw Self.ActivationError.disabled
                    case .cancelled:
                        throw Self.ActivationError.cancelled
                    @unknown default:
                        throw Self.ActivationError.unknown
                }
            } catch {
                print("Failed activation: \(error)")
                assertionFailure()
            }
        }
    }
    private enum ActivationError: Error {
        case failed, disabled, cancelled, unknown
    }
}
