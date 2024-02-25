import SwiftUI
import GroupActivities
import Combine

class 🥽AppModel: ObservableObject {
    @Published var pieces: Pieces = .empty
    @Published var side: Side = .white
    @Published var presentResult: Bool = false
    @Published var presentSettingPanel: Bool = false
    
    @Published var groupSession: GroupSession<👤GroupActivity>?
    var messenger: GroupSessionMessenger?
    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()
    
    let soundEffect: SoundEffect = .init()
}
