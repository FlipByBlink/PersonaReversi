import SwiftUI

@main
struct SpacialReversiApp: App {
    @StateObject private var model: AppModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.model)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: FixedValue.windowLength,
                     height: FixedValue.windowLength,
                     depth: FixedValue.windowLength)
        WindowGroup(id: "setting") {
            SettingView()
                .environmentObject(self.model)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 300, height: 300)
    }
}
