import SwiftUI

struct SettingView: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        NavigationStack {
            List {
                Button {
                    self.model.reset()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                Picker("Side", selection: self.$model.side) {
                    Label {
                        Text("White")
                    } icon: {
                        Color.white.clipShape(.circle)
                    }
                    .tag(Side.white)
                    Label {
                        Text("Black")
                    } icon: {
                        Color.black.clipShape(.circle)
                    }
                    .tag(Side.black)
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
            .navigationTitle("Setting")
        }
        .frame(width: 300, height: 300)
    }
}
