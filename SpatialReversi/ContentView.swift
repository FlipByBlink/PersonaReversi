import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        Group {
            if self.showEntrance {
                EntranceView()
                    .offset(y: -2600)
                    .offset(z: -1300)
            } else {
                ReversiView()
                    .offset(z: -1300)//実際には0
            }
        }
        .task {
            self.model.configureGroupSessions()
            👤Registration.execute()
        }
    }
}

private extension ContentView {
    private var showEntrance: Bool {
#if !DEBUG
        self.model.groupSession == nil
#else
//        true
        false
#endif
    }
}
