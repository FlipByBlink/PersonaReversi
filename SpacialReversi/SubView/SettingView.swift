import SwiftUI

struct SettingView: View {
    @EnvironmentObject var model: AppModel
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismissWindow) var dismissWindow
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
                ShareLink(item: 👤GroupActivity(),
                          preview: .init("SHAREPLAY"))
            }
            .navigationTitle("Setting")
        }
        .frame(width: 300, height: 500)
        .onAppear { self.model.presentSettingWindow = true }
        .onDisappear { self.model.presentSettingWindow = false }
        .onChange(of: self.scenePhase) { _, newValue in
            if newValue != .active {
                self.dismissWindow(id: "setting")
            }
        }
    }
}
