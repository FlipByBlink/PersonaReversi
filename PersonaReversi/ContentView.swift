import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        RealityView { content, attachments in
            content.add(attachments.entity(for: "guide")!)
            content.add(attachments.entity(for: "reversi")!)
        } attachments: {
            Attachment(id: "guide") { GuideView() }
            Attachment(id: "reversi") { ReversiView() }
        }
        .task { self.model.configureGroupSessions() }
        .task { 👤Registration.execute() }
        .frame(width: Size.window,
               height: Size.window)
        .frame(depth: Size.window)
    }
}
