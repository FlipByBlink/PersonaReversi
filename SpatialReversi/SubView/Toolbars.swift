import SwiftUI

struct ToolbarsView: View {
    var body: some View {
        ZStack {
            Self.ContentView()
                .offset(z: Size.board / 2)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(90), axis: .y))
                .offset(x: Size.board / 2)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(270), axis: .y))
                .offset(x: -Size.board / 2)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(180), axis: .y))
                .offset(z: -Size.board / 2)
        }
        .offset(y: Size.toolbarHeight / 2)
    }
}

private extension ToolbarsView {
    private struct ContentView: View {
        @EnvironmentObject var model: 🥽AppModel
        @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
        var body: some View {
            HStack(spacing: 24) {
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
                            .frame(width: 42, height: 42)
                            .overlay {
                                if self.model.side == side {
                                    Image(systemName: "checkmark")
                                        .font(.title.bold())
                                        .foregroundStyle(.green)
                                }
                            }
                    }
                }
                HStack(spacing: 8) {
                    Button {
                        self.model.raiseBoard()
                    } label: {
                        Image(systemName: "chevron.up")
                            .frame(width: 32, height: 32)
                    }
                    Button {
                        self.model.lowerBoard()
                    } label: {
                        Image(systemName: "chevron.down")
                            .frame(width: 32, height: 32)
                    }
                }
                .buttonBorderShape(.circle)
                Button {
                    Task {
                        await self.dismissImmersiveSpace()
                    }
                } label: {
                    Label("Exit", systemImage: "escape")
                        .padding(8)
                }
            }
            .opacity(self.model.presentResult ? 0 : 1)
            .buttonStyle(.plain)
            .padding(12)
            .padding(.horizontal, 24)
            .overlay {
                Button {
                    self.model.reset()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .font(.title3)
                        .padding(8)
                }
                .buttonStyle(.plain)
                .opacity(self.model.presentResult ? 1 : 0)
                .disabled(!self.model.presentResult)
            }
            .glassBackgroundEffect()
            .animation(.default.speed(0.33), value: self.model.presentResult)
            .frame(height: Size.toolbarHeight)
        }
    }
}