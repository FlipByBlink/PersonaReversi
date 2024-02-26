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
        .offset(y: -self.model.viewHeight.value)
#if DEBUG
        .offset(z: -1300)//実際には0
#endif
        .opacity(self.model.showReversi ? 1 : 0)
        .animation(.default, value: self.model.viewHeight.value)
        .animation(.default, value: self.model.showReversi)
#if DEBUG
        .onChange(of: self.model.showReversi) { _, newValue in
            if newValue == true {
                Task {
                    try? await Task.sleep(for: .seconds(1))
                    self.model.applyPreset()
                    //            self.model.setPiecesForDebug()
                    //            self.model.showResultView()
                }
            }
        }
#endif
    }
}
