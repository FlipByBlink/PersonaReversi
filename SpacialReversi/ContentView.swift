import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(1...8, id: \.self) { column in
                    VStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { row in
                            SquareView(index: column + row * 8)
                                .frame(width: proxy.size.width / 8,
                                       height: proxy.size.width / 8)
                        }
                    }
                }
            }
            .overlay {
                ZStack {
                    HStack(spacing: 0) {
                        ForEach(1...8, id: \.self) {
                            Spacer()
                            if $0 < 8 { Color.primary.frame(width: 1) }
                        }
                    }
                    VStack(spacing: 0) {
                        ForEach(1...8, id: \.self) {
                            Spacer()
                            if $0 < 8 { Color.primary.frame(height: 1) }
                        }
                    }
                }
                .border(.primary, width: 6)
            }
        }
        .padding(128)
        .glassBackgroundEffect()
        .rotation3DEffect(.init(angle: .degrees(90), axis: .x))
        .offset(y: (FixedValue.windowLength / 2) - FixedValue.toolbarHeight)
        .frame(width: FixedValue.windowLength, height: FixedValue.windowLength)
        .frame(depth: FixedValue.windowLength)
        .overlay(alignment: .bottom) { ToolbarView() }
        .overlay(alignment: .bottom) {
            ToolbarView()
                .offset(x: FixedValue.windowLength / 2)
                .offset(z: FixedValue.windowLength / 2)
                .rotation3DEffect(.init(angle: .degrees(90), axis: .y))
        }
        .overlay(alignment: .bottom) {
            ToolbarView()
                .offset(x: -FixedValue.windowLength / 2)
                .offset(z: FixedValue.windowLength / 2)
                .rotation3DEffect(.init(angle: .degrees(270), axis: .y))
        }
        .background(alignment: .bottom) {
            ToolbarView()
                .rotation3DEffect(.init(angle: .degrees(180), axis: .y))
        }
    }
}

fileprivate extension ContentView {
    struct ToolbarView: View {
        @EnvironmentObject var model: AppModel
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
                            .opacity(self.model.side == side ? 1 : 0.75)
                            .frame(width: 42, height: 42)
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
            .padding()
            .glassBackgroundEffect()
            .frame(height: FixedValue.toolbarHeight)
        }
    }
}

struct SquareView: View {
    var index: Int
    @EnvironmentObject var model: AppModel
    var body: some View {
        Color.clear
            .contentShape(.rect)
            .glassBackgroundEffect(in: .rect)
            .hoverEffect(isEnabled: self.model.pieces[self.index] == nil)
            .onTapGesture { self.model.set(self.index) }
            .overlay {
                if let piece = self.model.pieces[index] {
                    Self.PieceView(index: index, piece: piece)
                }
            }
    }
    private struct PieceView: View {
        var index: Int
        var piece: Piece
        @EnvironmentObject var model: AppModel
        var body: some View {
            Model3D(named: "Piece",
                    bundle: realityKitContentBundle) {
                $0
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.clear
            }
            .rotation3DEffect(.degrees(self.piece.degrees), axis: .y)
            .offset(z: self.piece.zOffset)
            .padding(12)
            .background {
                Circle()
                    .fill(.black)
                    .opacity(0.15)
                    .padding(12)
            }
            .opacity(self.piece.opacity)
            .onTapGesture { self.model.toggle(self.index) }
        }
    }
}
