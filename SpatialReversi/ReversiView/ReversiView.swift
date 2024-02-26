import SwiftUI
import RealityKit

struct ReversiView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        if self.model.showReversi {
            RealityView { content, attachments in
                content.add(attachments.entity(for: "board")!)
                content.add(attachments.entity(for: "toolbars")!)
                content.add(attachments.entity(for: "result")!)
            } attachments: {
                Attachment(id: "board") { BoardView() }
                Attachment(id: "toolbars") { ToolbarsView() }
                Attachment(id: "result") { ResultView() }
            }
            .task {
                try? await Task.sleep(for: .seconds(1))
                self.model.applyPreset()
                //            self.model.setPiecesForDebug()
                //            self.model.showResultView()
            }
            .offset(y: -self.model.viewHeight.value)
            .offset(z: -1300)//実際には0
            .animation(.default, value: self.model.viewHeight.value)
        }
    }
}
