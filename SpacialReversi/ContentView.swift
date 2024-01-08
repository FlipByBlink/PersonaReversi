import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    @Environment(\.openWindow) var openWindow
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
        .offset(y: windowLength / 2)
        .frame(width: windowLength, height: windowLength)
        .frame(depth: windowLength)
        .task { self.openWindow(id: "setting") }
    }
}

fileprivate extension ContentView {
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
