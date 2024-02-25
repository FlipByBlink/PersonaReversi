import SwiftUI

@main
struct SR_iOS_debugApp: App {
    @StateObject private var model: 🥽AppModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.model)
        }
    }
}
