import SwiftUI

struct Toolbars: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                Self.ContentView()
            }
            .overlay(alignment: .bottom) {
                Self.ContentView()
                    .offset(x: Size.windowLength / 2)
                    .offset(z: Size.windowLength / 2)
                    .rotation3DEffect(.init(angle: .degrees(90), axis: .y))
            }
            .overlay(alignment: .bottom) {
                Self.ContentView()
                    .offset(x: -Size.windowLength / 2)
                    .offset(z: Size.windowLength / 2)
                    .rotation3DEffect(.init(angle: .degrees(270), axis: .y))
            }
            .background(alignment: .bottom) {
                Self.ContentView()
                    .rotation3DEffect(.init(angle: .degrees(180), axis: .y))
            }
    }
}

private extension Toolbars {
    private struct ContentView: View {
        @EnvironmentObject var model: 🥽AppModel
        var body: some View {
            HStack(spacing: 16) {
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
                .opacity(self.model.presentResult ? 0 : 1)
            }
            .buttonStyle(.plain)
            .padding(12)
            .padding(.horizontal, 24)
            .glassBackgroundEffect()
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
            .animation(.default.speed(0.33), value: self.model.presentResult)
            .frame(height: Size.toolbarHeight)
        }
    }
}
