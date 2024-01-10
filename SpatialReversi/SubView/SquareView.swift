import SwiftUI

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
                    PieceView(index, piece)
                }
            }
    }
}
