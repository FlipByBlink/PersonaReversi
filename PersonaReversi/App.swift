import SwiftUI

@main
struct PersonaReversiApp: App {
    @StateObject private var model: 🥽AppModel = .init()
    var body: some Scene {
        ImmersiveSpace {
            ContentView()
                .environmentObject(self.model)
        }
    }
}
