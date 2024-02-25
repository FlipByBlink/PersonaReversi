import SwiftUI
import GroupActivities
import Combine

class 🥽AppModel: ObservableObject {
    @Published var pieces: Pieces = .empty
    @Published var side: Side = .white
    @Published var presentResult: Bool = false
    
    @Published var groupSession: GroupSession<👤GroupActivity>?
    var messenger: GroupSessionMessenger?
    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()
    @Published var isSpatial: Bool? = nil
    
    let soundEffect: SoundEffect = .init()
}
