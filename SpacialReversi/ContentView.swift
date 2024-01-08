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
                                .overlay { Self.PieceView(index: index) }
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
    struct PieceView: View {
        var index: Int
        @EnvironmentObject var model: AppModel
        @State private var phase: Self.Phase = .init(side: .white, stage: .appear)
        private var side: Side? { self.model.pieces[index] }
        var body: some View {
            if let side {
                Model3D(named: "Piece",
                        bundle: realityKitContentBundle) {
                    $0
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotation3DEffect(.degrees(self.phase.side == .black ? 180 : 0), axis: .y)
                        .offset(z: [.appear, .fadeIn, .slideUp, .flip].contains(self.phase.stage) ? 70 : 0)
                        .padding(12)
                        .background {
                            Circle()
                                .fill(.black)
                                .opacity(0.15)
                                .padding(12)
                        }
                        .opacity(self.phase.stage == .appear ? 0 : 1)
                        .task {
                            self.phase.side = side
                            withAnimation(.default.speed(2)) {
                                self.phase.stage = .fadeIn
                            } completion: {
                                withAnimation { self.phase.stage = .slideDown }
                            }
                        }
                        .onChange(of: self.side) { o, n in
                            withAnimation {
                                self.phase.stage = .slideUp
                            } completion: {
                                withAnimation {
                                    self.phase.stage = .flip
                                    self.phase.side = (self.phase.side == .black ? .white : .black)
                                } completion: {
                                    withAnimation { self.phase.stage = .slideDown }
                                }
                            }
                        }
                        .onTapGesture {
                            self.model.pieces[self.index] = (self.side == .black ? .white : .black)
                        }
                } placeholder: {
                    Color.clear
                }
            }
        }
        private struct Phase {
            var side: Side
            var stage: Self.Stage
            enum Stage {
                case appear, fadeIn, slideDown, flip, slideUp, complete
            }
        }
    }
}

struct SquareView: View {
    var index: Int
    @EnvironmentObject var model: AppModel
    @State private var phase: Self.Phase = .init(side: .white, stage: .appear)
    var body: some View {
        
    }
}
