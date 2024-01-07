import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State private var pieces: [Int: Side] = [28: .black, 29: .white,
                                              36: .white, 37: .black]
    var body: some View {
        GeometryReader { proxy in
            let boardLength = proxy.size.width / 8
            HStack(spacing: 0) {
                ForEach(1 ... 8, id: \.self) { column in
                    VStack(spacing: 0) {
                        ForEach(0 ..< 8, id: \.self) { row in
                            let index = column + row * 8
                            Color.clear
                                .contentShape(.rect)
                                .glassBackgroundEffect(in: .rect)
                                .hoverEffect(isEnabled: self.pieces[index] == nil)
                                .onTapGesture {
                                    self.pieces[index] = Bool.random() ? .black : .white
                                }
                                .overlay {
                                    switch self.pieces[index] {
                                        case .black: Self.PieceView(side: .black)
                                        case .white: Self.PieceView(side: .white)
                                        case .none: EmptyView()
                                    }
                                }
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
        .offset(y: windowLength / 2)
        .frame(width: windowLength, height: windowLength)
        .frame(depth: windowLength)
    }
}

enum Side {
    case white, black
}

fileprivate extension ContentView {
    struct PieceView: View {
        var side: Side
        @State private var opacity: Double = 0
        @State private var floating: Bool = true
        var body: some View {
            Model3D(named: self.side == .black ? "BlackPiece" : "WhitePiece",
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
