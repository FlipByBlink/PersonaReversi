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
        @State private var showSharePlaySubmenu: Bool = false
        var body: some View {
            HStack(spacing: 24) {
                Button {
                    Task {
                        await self.dismissImmersiveSpace()
                    }
                } label: {
                    Label("Exit", systemImage: "escape")
                        .padding(16)
                        .font(.title)
                }
                .padding(12)
                .glassBackgroundEffect()
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
                        }
                    }
                    HStack(spacing: 6) {
                        Button {
                            self.model.raiseBoard()
                        } label: {
                            Image(systemName: "chevron.up")
                                .frame(width: 32, height: 32)
                                .padding(8)
                        }
                        Button {
                            self.model.lowerBoard()
                        } label: {
                            Image(systemName: "chevron.down")
                                .frame(width: 32, height: 32)
                                .padding(8)
                        }
                    }
                    .font(.title)
                    .buttonBorderShape(.circle)
                    Button {
                        self.model.reset()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .padding(12)
                            .minimumScaleFactor(0.5)
                            .font(.title)
                    }
                    if true {
//                    if self.model.groupSession?.state == .joined {
                        Button {
                            self.showSharePlaySubmenu.toggle()
                        } label: {
                            Label("SharePlay menu", systemImage: "shareplay")
                                .padding()
                                .labelStyle(.iconOnly)
                                .background {
                                    if self.showSharePlaySubmenu {
                                        Circle()
                                            .foregroundStyle(.tertiary)
                                    }
                                }
                        }
                        .font(.title)
                        .buttonBorderShape(.circle)
                        .overlay {
                            if self.showSharePlaySubmenu {
                                VStack {
                                    HStack {
                                        Text("Activity state: ?")
                                        Spacer()
                                        Text("?")
                                            .foregroundStyle(.secondary)
                                    }
                                    HStack {
                                        Text("Participants count: ?")
                                        Spacer()
                                        Text("?")
                                            .foregroundStyle(.secondary)
                                    }
                                    Button("Leave activity") {}
                                    Button("Close activity") {}
                                }
                                .padding(24)
                                .glassBackgroundEffect()
                                .offset(y: 100)
                                .frame(width: 300, height: 300)
                                .offset(z: 10)
                            }
                        }
                    }
                }
                .padding(12)
                .padding(.horizontal, 40)
                .frame(height: Size.toolbarHeight)
                .glassBackgroundEffect()
            }
            .buttonStyle(.plain)
            .animation(.default, value: self.model.groupSession?.state == .joined)
            .animation(.default, value: self.showSharePlaySubmenu)
            .rotation3DEffect(.degrees(20), axis: .x)
        }
    }
}
