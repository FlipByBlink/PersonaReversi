import SwiftUI
import RealityKit
import RealityKitContent

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
}

private extension SquareView {
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
            .rotation3DEffect(self.piece.angle, axis: .y)
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
