import SwiftUI

struct SettingPanel: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        if self.model.presentSettingPanel {
            NavigationStack {
                List {
                    Button {
                        self.model.reset()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                }
                .navigationTitle("Setting")
                .font(.largeTitle)
            }
            .frame(width: 400, height: 400)
        }
    }
}
