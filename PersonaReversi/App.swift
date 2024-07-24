import SwiftUI

@main
struct PersonaReversiApp: App {
    @StateObject private var model = 🥽AppModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.model)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: Size.window,
                     height: Size.window,
                     depth: Size.window)
    }
}
