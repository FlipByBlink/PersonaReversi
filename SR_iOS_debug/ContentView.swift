import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        VStack {
            BoardView()
            Picker("Side", selection: self.$model.side) {
                Text("White").tag(Side.white)
                Text("Black").tag(Side.black)
            }
            ShareLink(item: 👤GroupActivity(),
                      preview: .init("SHAREPLAY"))
        }
        .task {
            for await session in 👤GroupActivity.sessions() {
                self.model.configureGroupSession(session)
            }
        }
        .task { 👤Registration.execute() }
        .task { self.model.applyPreset() }
        .task { 📢SoundEffect.setCategory() }
    }
}

struct BoardView: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(1...8, id: \.self) { column in
                    VStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { row in
                            let index: Int = column + row * 8
                            Color.clear
                                .contentShape(.rect)
                                .onTapGesture { self.model.set(index) }
                                .overlay {
                                    if let piece = self.model.pieces[index] {
                                        PieceView(index, piece)
                                    }
                                }
                                .frame(width: proxy.size.width / 8,
                                       height: proxy.size.width / 8)
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
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(lineWidth: 5)
            }
        }
        .padding()
    }
}

struct PieceView: View {
    var index: Int
    var piece: Piece
    @EnvironmentObject var model: AppModel
    var body: some View {
        Circle()
            .fill(self.piece.side == .white ? .white : .black)
            .overlay { Circle().stroke() }
            .padding(4)
            .onTapGesture { self.model.toggle(self.index) }
    }
    init(_ index: Int, _ piece: Piece) {
        self.index = index
        self.piece = piece
    }
}
