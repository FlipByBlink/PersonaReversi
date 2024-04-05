import SwiftUI
import RealityKit
import RealityKitContent

struct PieceView: View {
    var index: Int
    var piece: Piece
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        Model3D(named: "Piece", bundle: realityKitContentBundle) {
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
    }
    init(_ index: Int, _ piece: Piece) {
        self.index = index
        self.piece = piece
    }
}
