import SwiftUI
import GroupActivities
import Combine

class AppModel: ObservableObject {
    @Published var pieces: Pieces = .init()
    @Published var side: Side = .white
    @Published var presentResult: Bool = false
    @Published var presentSettingWindow: Bool = false
    
    @Published var groupSession: GroupSession<👤GroupActivity>?
    var messenger: GroupSessionMessenger?
    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()
}

extension AppModel {
    func startSharing() {
        Task {
            do {
                _ = try await 👤GroupActivity().activate()
            } catch {
                print("Failed to activate activity: \(error)")
            }
        }
    }
    func configureGroupSession(_ groupSession: GroupSession<👤GroupActivity>) {
        self.pieces = .init()
        
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
                    try? await messenger.send(self.pieces, to: .only(newParticipants))
                }
            }
            .store(in: &subscriptions)
        
        let task = Task {
            for await (message, _) in messenger.messages(of: Pieces.self) {
                self.pieces = message
            }
        }
        self.tasks.insert(task)
        
#if os(visionOS)
        Task {
            if let systemCoordinator = await groupSession.systemCoordinator {
                for await localParticipantState in systemCoordinator.localParticipantStates {
                    if localParticipantState.isSpatial {
                        // Start syncing spacial-actions
                    } else {
                        // Stop syncing spacial-actions
                    }
                }
            }
        }
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
                configuration.spatialTemplatePreference = .conversational
                configuration.supportsGroupImmersiveSpace = true
                systemCoordinator.configuration = configuration
                groupSession.join()
            }
        }
#else
        groupSession.join()
#endif
    }
    func restartGroupActivity() {
        self.reset()
        
        self.messenger = nil
        self.tasks.forEach { $0.cancel() }
        self.tasks = []
        self.subscriptions = []
        if self.groupSession != nil {
            self.groupSession?.leave()
            self.groupSession = nil
            //self.startSharing()
        }
    }
    func sync() {
        Task {
            try? await self.messenger?.send(self.pieces)
        }
    }
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
                        self.handleSetEffect(index)
                        self.handleResultView()
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
            self.presentResult = false
            self.pieces = .init()
        } completion: {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                self.applyPreset()
            }
        }
    }
}

fileprivate extension AppModel {
    private func handleSetEffect(_ index: Int) {
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
