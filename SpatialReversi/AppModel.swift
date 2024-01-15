import SwiftUI
import GroupActivities
import Combine

class AppModel: ObservableObject {
    @Published var pieces: Pieces = .init()
    @Published var side: Side = .white
    @Published var presentResult: Bool = false
    @Published var presentSettingPanel: Bool = false
    
    @Published var groupSession: GroupSession<👤GroupActivity>?
    var messenger: GroupSessionMessenger?
    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()
    
    let soundEffect: 📢SoundEffect = .init()
}

extension AppModel {
    func activateGroupActivity() {
        Task {
            do {
                _ = try await 👤GroupActivity().activate()
            } catch {
                print("Failed to activate activity: \(error)")
            }
        }
    }
    func configureGroupSession(_ groupSession: GroupSession<👤GroupActivity>) {
        self.reset()
        
        self.groupSession = groupSession
        let messenger = GroupSessionMessenger(session: groupSession)
        self.messenger = messenger
        
        groupSession.$state
            .sink { state in
                if case .invalidated = state {
                    self.groupSession = nil
                    self.reset()
                }
            }
            .store(in: &subscriptions)
        
        groupSession.$activeParticipants
            .sink { activeParticipants in
                let newParticipants = activeParticipants.subtracting(groupSession.activeParticipants)
                Task {
                    try? await messenger.send(👤Message(pieces: self.pieces,
                                                        animate: .default(),
                                                        playingSound: false),
                                              to: .only(newParticipants))
                }
            }
            .store(in: &subscriptions)
        
        let task = Task {
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
        self.tasks.insert(task)
        
#if os(visionOS)
        //Task {
        //    if let systemCoordinator = await groupSession.systemCoordinator {
        //        for await localParticipantState in systemCoordinator.localParticipantStates {
        //            if localParticipantState.isSpatial {
        //                // Start syncing spacial-actions
        //            } else {
        //                // Stop syncing spacial-actions
        //            }
        //        }
        //    }
        //}
        
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
                configuration.spatialTemplatePreference = .none
                //configuration.supportsGroupImmersiveSpace = true
                systemCoordinator.configuration = configuration
                groupSession.join()
            }
        }
#else
        groupSession.join()
#endif
    }
    //func restartGroupActivity() {
    //    self.reset()
    //
    //    self.messenger = nil
    //    self.tasks.forEach { $0.cancel() }
    //    self.tasks = []
    //    self.subscriptions = []
    //    if self.groupSession != nil {
    //        self.groupSession?.leave()
    //        self.groupSession = nil
    //        self.activateGroupActivity()
    //    }
    //}
    func send(animate: 👤Message.Animate = .default(), playingSound: Bool = false) {
        Task {
            try? await self.messenger?.send(👤Message(pieces: self.pieces,
                                                      animate: animate,
                                                      playingSound: playingSound))
        }
    }
}

extension AppModel {
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
                        self.soundEffect.execute()
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
            self.pieces = .init()
            self.send()
        } completion: {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                self.applyPreset()
            }
        }
    }
}

fileprivate extension AppModel {
    private func handleResultView() {
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2))
            if self.pieces.isMax {
                withAnimation {
                    self.presentResult = true
                }
            }
        }
    }
}

extension AppModel {
    func setPiecesForDebug() {
#if DEBUG
        Task { @MainActor in
            for index in (1...64) {
                if ![28, 29, 36, 37, 63].contains(index) {
                    try? await Task.sleep(for: .seconds(0.1))
                    self.set(index)
                }
            }
        }
#endif
    }
}
