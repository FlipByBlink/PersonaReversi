import SwiftUI
import GroupActivities
import Combine

@MainActor
class 🥽AppModel: ObservableObject {
    @Published var activityState: ActivityState = .init()
    
    @Published var side: Side = .white
    
    @Published var groupSession: GroupSession<👤GroupActivity>?
    var messenger: GroupSessionMessenger?
    var subscriptions: Set<AnyCancellable> = []
    var tasks: Set<Task<Void, Never>> = []
    @Published var isSpatial: Bool?
    
    let soundFeedback: SoundFeedback = .init()
}
