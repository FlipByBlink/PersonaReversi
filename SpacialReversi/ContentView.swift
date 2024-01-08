import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        GeometryReader { proxy in
            let boardLength = proxy.size.width / 8
            HStack(spacing: 0) {
                ForEach(1...8, id: \.self) { column in
                    VStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { row in
                            let index = column + row * 8
                            Color.clear
                                .contentShape(.rect)
                                .glassBackgroundEffect(in: .rect)
                                .hoverEffect(isEnabled: self.model.pieces[index] == nil)
                                .onTapGesture { self.model.set(index) }
                                .overlay { Self.PieceView(side: self.model.pieces[index]) }
                                .frame(width: boardLength, height: boardLength)
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
                        withAnimation {
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
    struct PieceView: View {
        var side: Side?
        @State private var opacity: Double = 0
        @State private var floating: Bool = true
        var body: some View {
            if let side {
                Model3D(named: side == .black ? "BlackPiece" : "WhitePiece",
                        bundle: realityKitContentBundle) {
                    $0
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .offset(z: self.floating ? 70 : 0)
                        .opacity(self.opacity)
                        .padding(12)
                        .task {
                            try? await Task.sleep(for: .seconds(0.1))
                            withAnimation(.default.speed(2)) { self.opacity = 1 }
                            try? await Task.sleep(for: .seconds(0.4))
                            withAnimation { self.floating = false }
                        }
                } placeholder: {
                    Color.clear
                }
                .background {
                    Circle()
                        .fill(.black)
                        .opacity(0.15 * self.opacity)
                        .padding(12)
                }
            }
        }
    }
}
