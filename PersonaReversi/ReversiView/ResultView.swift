import SwiftUI
import RealityKit
import RealityKitContent

struct ResultView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        if self.model.showResult {
            Self.ContentView()
        }
    }
}

private extension ResultView {
    private struct ContentView: View {
        @EnvironmentObject var model: 🥽AppModel
        @State private var yOffset: Double = 400
        @State private var opacity: Double = 0
        @State private var showedDate: Date = .now
        var body: some View {
            TimelineView(.animation) { context in
                VStack(spacing: 64) {
                    ForEach([Side.white, .black], id: \.self) { side in
                        HStack(spacing: 32) {
                            Model3D(named: side == .white ? "WhitePiece" : "BlackPiece",
                                    bundle: realityKitContentBundle) {
                                $0
                                    .resizable()
                                    .scaledToFit()
                                    .offset(z: 100)
                            } placeholder: {
                                Color.clear
                            }
                            .frame(width: 200, height: 200)
                            RealityView { content in
                                let text = "\(self.model.activityState.pieces.pieceCounts[side] ?? 0)"
                                let textMeshResource: MeshResource = .generateText(text,
                                                                                   extrusionDepth: 0.015,
                                                                                   font: .systemFont(ofSize: 0.15,
                                                                                                     weight: .heavy))
                                let textEntity = ModelEntity(mesh: textMeshResource,
                                                             materials: [SimpleMaterial(color: .white,
                                                                                        isMetallic: false)])
                                textEntity.position = -(textMeshResource.bounds.extents / 2)
                                textEntity.position.y -= 0.04
                                content.add(textEntity)
                            }
                            .frame(width: 350, height: 200)
                        }
                    }
                }
                .font(.system(size: 200))
                .frame(depth: 200)
                .rotation3DEffect(.degrees(context.date.timeIntervalSince(self.showedDate) * 6),
                                  axis: .y)
            }
            .offset(y: self.yOffset)
            .offset(y: -600)
            .opacity(self.opacity)
            .task {
                try? await Task.sleep(for: .seconds(1))
                withAnimation(.default.speed(0.25)) {
                    self.yOffset = 0
                    self.opacity = 1
                }
            }
            .onChange(of: self.model.activityState.pieces.isFinished) { _, newValue in
                if newValue == false {
                    withAnimation {
                        self.opacity = 0
                    } completion: {
                        self.model.showResult = false
                    }
                }
            }
        }
    }
}
