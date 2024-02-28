import SwiftUI
import RealityKit

struct ReversiView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        RealityView { content, attachments in
            content.add(attachments.entity(for: "board")!)
            content.add(attachments.entity(for: "toolbars")!)
            content.add(attachments.entity(for: "result")!)
        } attachments: {
            Attachment(id: "board") { BoardView() }
            Attachment(id: "toolbars") { ToolbarsView() }
            Attachment(id: "result") { ResultView() }
        }
        .offset(y: -(self.model.viewHeight?.value ?? ViewHeight.default.value))
#if targetEnvironment(simulator)
        .offset(z: -1300)//実際には0
#else
        .offset(z: self.model.isSpatial == true ? 0 : -1300)
#endif
        .opacity(self.model.showReversi ? 1 : 0)
        .animation(.default, value: self.model.viewHeight?.value)
        .animation(.default, value: self.model.showReversi)
#if targetEnvironment(simulator)
        .task {
            try? await Task.sleep(for: .seconds(1))
            self.model.setUpForDebug()
//            try? await Task.sleep(for: .seconds(2))
//            self.model.setPiecesForDebug()
        }
#endif
    }
}
