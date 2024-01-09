import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        BoardView()
            .rotation3DEffect(.init(angle: .degrees(90), axis: .x))
            .offset(y: (FixedValue.windowLength / 2) - FixedValue.toolbarHeight)
            .frame(width: FixedValue.windowLength, height: FixedValue.windowLength)
            .frame(depth: FixedValue.windowLength)
            .modifier(Toolbar())
            .task { self.model.applyPreset() }
            .modifier(ResultEffect())
    }
}
