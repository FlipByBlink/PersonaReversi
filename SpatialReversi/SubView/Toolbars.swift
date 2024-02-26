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
        .offset(y: (Size.toolbarHeight / 2) + 20)
    }
}

private extension ToolbarsView {
    private struct ContentView: View {
        @EnvironmentObject var model: 🥽AppModel
        @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
        var body: some View {
            HStack(spacing: 0) {
                if !self.model.presentResult {
                    Button {
                        Task {
                            await self.dismissImmersiveSpace()
                        }
                    } label: {
                        Label("Exit", systemImage: "escape")
                            .padding(12)
                    }
                    .frame(width: 160)
                    Spacer()
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
                                    .frame(width: 48, height: 48)
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
                    Spacer()
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
                    .buttonBorderShape(.circle)
                    .frame(width: 160)
                } else {
                    Button {
                        self.model.reset()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.title3)
                            .padding(12)
                            .minimumScaleFactor(0.5)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(12)
            .frame(width: Size.square * 4, height: Size.toolbarHeight)
            .glassBackgroundEffect()
            .rotation3DEffect(.degrees(20), axis: .x)
            .animation(.default.speed(0.5), value: self.model.presentResult)
        }
    }
}
