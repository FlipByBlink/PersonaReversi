import SwiftUI

struct EntranceView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        NavigationStack {
            List {
                Button("Start activity") {
                    self.model.activateGroupActivity()
                }
            }
            .navigationTitle("SpatialReversi")
        }
        .frame(width: 600, height: 600)
        .glassBackgroundEffect()
    }
}
