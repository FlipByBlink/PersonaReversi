import SwiftUI

@main
struct SpatialReversiApp: App {
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
    }
}
