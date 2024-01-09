import SwiftUI
import RealityKit
import RealityKitContent

struct ResultEffect: ViewModifier {
    @EnvironmentObject var model: AppModel
    @State private var yOffset: Double = 400
    @State private var opacity: Double = 0
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if self.model.presentResult {
                    TimelineView(.animation) { context in
                        VStack(spacing: 64) {
                            ForEach([Side.white, .black], id: \.self) { side in
                                HStack(spacing: 32) {
                                    Model3D(named: side == .white ? "WhitePiece" : "BlackPiece",
                                            bundle: realityKitContentBundle) {
                                        $0
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        Color.clear
                                    }
                                    .frame(width: 200, height: 200)
                                    RealityView { content in
                                        let text = "\(self.model.pieces.pieceCounts[side] ?? 0)"
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
                                    .frame(width: 200, height: 200)
                                }
                            }
                        }
                        .font(.system(size: 200))
                        .rotation3DEffect(.degrees(context.date.timeIntervalSinceReferenceDate * 16),
                                          axis: .y)
                        .offset(z: -FixedValue.windowLength / 2)
                    }
                    .offset(y: self.yOffset)
                    .opacity(self.opacity)
                    .task {
                        withAnimation(.default.speed(0.25)) {
                            self.yOffset = 0
                            self.opacity = 1
                        }
                    }
                }
            }
#if DEBUG
            .task {
                try? await Task.sleep(for: .seconds(2))
                self.model.presentResult = true
            }
#endif
    }
}
