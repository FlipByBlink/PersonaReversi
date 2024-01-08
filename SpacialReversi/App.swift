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
        .defaultSize(width: windowLength,
                     height: windowLength,
                     depth: windowLength)
        WindowGroup(id: "setting") {
            SettingView()
                .environmentObject(self.model)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 300, height: 300)
    }
}

let windowLength: CGFloat = 1200.0
