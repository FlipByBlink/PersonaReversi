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
    }
}

let windowLength: CGFloat = 1200.0
