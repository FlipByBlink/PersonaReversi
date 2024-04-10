import SwiftUI

struct ToolbarsView: View {
    var body: some View {
        ZStack {
            Self.ContentView()
                .offset(z: Size.toolbarOffset)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(90), axis: .y))
                .offset(x: Size.toolbarOffset)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(270), axis: .y))
                .offset(x: -Size.toolbarOffset)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(180), axis: .y))
                .offset(z: -Size.toolbarOffset)
        }
        .offset(y: (Size.toolbarHeight / 2) + 24)
    }
}

private extension ToolbarsView {
    private struct ContentView: View {
        @EnvironmentObject var model: 🥽AppModel
        @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
        @State private var showSharePlaySubMenu: Bool = false
        var body: some View {
            HStack(spacing: 24) {
                HStack(spacing: 24) {
                    HStack(spacing: 20) {
                        ForEach([Side.white, .black], id: \.self) { side in
                            Button {
                                withAnimation(.default.speed(1.5)) {
                                    self.model.side = side
                                }
                            } label: {
                                Circle()
                                    .fill(side == .white ? .white : .black)
                                    .opacity(self.model.side == side ? 0.9 : 0.75)
                                    .shadow(color: .gray, radius: 2)
                                    .frame(width: 54, height: 54)
                                    .overlay {
                                        if self.model.side == side {
                                            Image(systemName: "checkmark")
                                                .font(.title.bold())
                                                .foregroundStyle(.green)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Button {
                        self.model.reset()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .padding(12)
                            .minimumScaleFactor(0.5)
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                    if self.isSharePlaying {
                        Button {
                            self.showSharePlaySubMenu = true
                        } label: {
                            Image(systemName: "shareplay")
                                .padding()
                                .opacity(self.showSharePlaySubMenu ? 0.5 : 1)
                                .overlay {
                                    if self.model.groupSession?.state == .waiting {
                                        ProgressView()
                                    }
                                }
                        }
                        .font(.title)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.plain)
                    }
                }
                .padding(12)
                .padding(.horizontal, 40)
                .frame(height: Size.toolbarHeight)
                .glassBackgroundEffect()
            }
            .rotation3DEffect(.degrees(20), axis: .x)
            .overlay(alignment: .bottom) {
                if self.showSharePlaySubMenu { self.sharePlaySubMenu() }
            }
            .animation(.default, value: self.isSharePlaying)
            .animation(.default, value: self.showSharePlaySubMenu)
        }
        private var isSharePlaying: Bool {
#if targetEnvironment(simulator)
            true
//            false
#else
            [.waiting, .joined].contains(self.model.groupSession?.state)
#endif
        }
        private func sharePlaySubMenu() -> some View {
            VStack {
                HStack {
                    Button {
                        self.showSharePlaySubMenu = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                    }
                    .font(.title)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.plain)
                    Spacer()
                    Text("SharePlay state:")
                    Text({
                        switch self.model.groupSession?.state {
                            case .waiting:
                                "waiting"
                            case .joined:
                                "joined"
                            case .invalidated(reason: let error):
                                "invalidated, (\(error.localizedDescription))"
                            case .none:
                                "none"
                            @unknown default:
                                "unknown"
                        }
                    }() as LocalizedStringKey)
                    .scaleEffect(0.8)
                    .foregroundStyle(.secondary)
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(8)
                Divider()
                VStack {
                    Button {
                        self.model.groupSession?.leave()
                        self.showSharePlaySubMenu = false
                    } label: {
                        Text("Leave the activity")
                    }
                    Text("Everyone remains in the activity except you.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
                Divider()
                VStack {
                    Button("End the activity") {
                        self.model.groupSession?.end()
                        self.showSharePlaySubMenu = false
                    }
                    Text("Everyone will leave the activity.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(8)
            }
            .padding(24)
            .glassBackgroundEffect()
            .frame(width: 640, height: 400, alignment: .bottom)
            .offset(z: 30)
            .alignmentGuide(.bottom) { $0.height }
        }
    }
}
