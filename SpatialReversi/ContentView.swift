import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        RealityView { content, attachments in
            content.add(attachments.entity(for: "entrance")!)
            content.add(attachments.entity(for: "reversi")!)
        } attachments: {
            Attachment(id: "entrance") { EntranceView() }
            Attachment(id: "reversi") { ReversiView() }
        }
        .animation(.default, value: self.model.showEntrance)
        .animation(.default, value: self.model.showReversi)
        .task {
            self.model.configureGroupSessions()
            👤Registration.execute()
        }
    }
}
