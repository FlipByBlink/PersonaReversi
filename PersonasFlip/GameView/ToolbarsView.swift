import SwiftUI
import GroupActivities

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
        @State private var isPresentedSharePlaySubMenu: Bool = false
        var body: some View {
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
                                .frame(width: 54, height: 54)
                                .overlay {
                                    if self.model.side == side {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 28, height: 28)
                                            .fontWeight(.heavy)
                                            .foregroundStyle(Color(uiColor: {
                                                switch self.model.side {
                                                    case .white: .gray
                                                    case .black: .lightGray
                                                }
                                            }()))
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                        .disabled(self.model.side == side)
                    }
                }
                Divider()
                    .padding(.vertical)
                Button {
                    self.model.reset()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .padding(12)
                        .minimumScaleFactor(0.5)
                        .font(.title)
                }
                .buttonStyle(.plain)
                if let groupSession = self.model.groupSession {
                    Self.SharePlaySubMenuButton(
                        groupSession: groupSession,
                        isPresented: self.$isPresentedSharePlaySubMenu
                    )
                }
            }
            .padding(12)
            .padding(.horizontal, 32)
            .frame(height: Size.toolbarHeight)
            .glassBackgroundEffect(in: .capsule)
            .rotation3DEffect(.init(angle: .degrees(20), axis: .x))
            .overlay(alignment: .bottom) {
                if self.isPresentedSharePlaySubMenu { self.sharePlaySubMenu() }
            }
            .animation(.default, value: self.isPresentedSharePlaySubMenu)
        }
        private struct SharePlaySubMenuButton: View {
            @EnvironmentObject var model: 🥽AppModel
            @ObservedObject var groupSession: GroupSession<👤GroupActivity>
            @Binding var isPresented: Bool
            var body: some View {
                if [.waiting, .joined].contains(self.groupSession.state) {
                    Button {
                        self.isPresented = true
                    } label: {
                        Image(systemName: "shareplay")
                            .padding()
                            .opacity(self.isPresented ? 0.5 : 1)
                            .overlay {
                                if self.groupSession.state == .waiting {
                                    ProgressView()
                                }
                            }
                    }
                    .font(.title)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.plain)
                    .animation(.default, value: self.isPresented)
                }
            }
        }
        private struct SharePlayStateView: View {
            @ObservedObject var groupSession: GroupSession<👤GroupActivity>
            var body: some View {
                Text({
                    switch self.groupSession.state {
                        case .waiting:
                            "waiting"
                        case .joined:
                            "joined"
                        case .invalidated(reason: let error):
                            "invalidated, (\(error.localizedDescription))"
                        @unknown default:
                            "unknown"
                    }
                }() as LocalizedStringKey)
                .scaleEffect(0.8)
                .foregroundStyle(.secondary)
            }
        }
        private func sharePlaySubMenu() -> some View {
            VStack {
                HStack {
                    Button {
                        self.isPresentedSharePlaySubMenu = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                    }
                    .font(.title)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.plain)
                    Spacer()
                    Text("SharePlay state:")
                    if let groupSession = model.groupSession {
                        SharePlayStateView(groupSession: groupSession)
                    }
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(8)
                Divider()
                VStack {
                    Button {
                        self.model.groupSession?.leave()
                        self.isPresentedSharePlaySubMenu = false
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
                        self.isPresentedSharePlaySubMenu = false
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
