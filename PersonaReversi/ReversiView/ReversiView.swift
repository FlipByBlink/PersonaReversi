import SwiftUI
import RealityKit

struct ReversiView: View {
    @EnvironmentObject var model: 🥽AppModel
    @Environment(\.physicalMetrics) var physicalMetrics
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
        .offset(y: -self.yOffset)
        .offset(z: -self.zOffset)
        .animation(.default, value: self.yOffset)
#if targetEnvironment(simulator)
        .task {
//            try? await Task.sleep(for: .seconds(1))
//            self.model.setUpForDebug()
//            try? await Task.sleep(for: .seconds(2))
//            self.model.setPiecesForDebug()
        }
#endif
    }
}

private extension ReversiView {
    private var yOffset: CGFloat {
        self.physicalMetrics.convert(self.model.activityState.viewHeight.value,
                                     from: .meters)
    }
    private var zOffset: CGFloat {
        if self.model.isSpatial == true {
            0
        } else {
            self.physicalMetrics.convert(Size.zOffsetInNonSpatial, from: .meters)
        }
    }
}
