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
        .task { self.model.configureGroupSessions() }
//        .task { 👤Registration.execute() }
    }
}
