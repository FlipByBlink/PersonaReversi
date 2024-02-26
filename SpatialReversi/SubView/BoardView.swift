import SwiftUI

struct BoardView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...8, id: \.self) { column in
                VStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { row in
                        SquareView(index: column + row * 8)
                            .frame(width: Size.square,
                                   height: Size.square)
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
        }
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(lineWidth: 5)
        }
        .padding(Size.boardPadding)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 96))
        .frame(width: Size.board, height: Size.board)
        .rotation3DEffect(.init(angle: .degrees(90), axis: .x))
    }
}
