import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        BoardView()
            .rotation3DEffect(.init(angle: .degrees(90), axis: .x))
            .offset(y: (Size.windowLength / 2) - Size.toolbarHeight)
            .frame(width: Size.windowLength, height: Size.windowLength)
            .frame(depth: Size.windowLength)
            .modifier(Toolbars())
            .modifier(ResultEffect())
            .task {
                self.model.configureGroupSessions()
                self.model.applyPreset()
                👤Registration.execute()
                self.model.setPiecesForDebug()
            }
    }
}
