import SwiftUI

@main
struct SpacialReversiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.volumetric)
        .defaultSize(width: windowLength, height: windowLength, depth: windowLength)
    }
}

let windowLength: CGFloat = 1200.0
