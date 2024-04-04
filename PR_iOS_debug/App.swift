import SwiftUI

@main
struct PR_iOS_debugApp: App {
    @StateObject private var model: 🥽AppModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.model)
        }
    }
}
