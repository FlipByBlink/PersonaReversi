import SwiftUI

struct SquareView: View {
    var index: Int
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .hoverEffect(isEnabled: self.model.puttable(self.index))
            .onTapGesture {
                if self.model.puttable(self.index) {
                    self.model.set(self.index)
                }
            }
            .overlay {
                if let piece = self.model.activityState.pieces[index] {
                    PieceView(index, piece)
                }
            }
    }
}
