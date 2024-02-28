import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        VStack {
            if self.model.showEntrance {
                Button("Start activity!") {
                    self.model.activateGroupActivity()
                }
            }
            if self.model.showReversi {
                BoardView()
                    .offset(y: (ViewHeight.default.value-self.model.viewHeight.value)/3)
                HStack {
                    Picker("Side", selection: self.$model.side) {
                        Text("White").tag(Side.white)
                        Text("Black").tag(Side.black)
                    }
                    HStack(spacing: 6) {
                        Button {
                            self.model.raiseBoard()
                        } label: {
                            Image(systemName: "chevron.up")
                                .frame(width: 32, height: 32)
                                .padding(8)
                        }
                        Button {
                            self.model.lowerBoard()
                        } label: {
                            Image(systemName: "chevron.down")
                                .frame(width: 32, height: 32)
                                .padding(8)
                        }
                    }
                    Button("reset") {
                        
                    }
                }
            }
        }
        .task {
            self.model.configureGroupSessions()
            self.model.applyPreset()
        }
    }
}

struct BoardView: View {
    @EnvironmentObject var model: 🥽AppModel
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
            .overlay {
                if self.model.presentResult {
                    Text("""
                    ⚫️ \(self.model.pieces.pieceCounts[.black] ?? 0)
                    ⚪️ \(self.model.pieces.pieceCounts[.white] ?? 0)
                    """)
                    .font(.system(size: 50).bold())
                    .foregroundStyle(.green)
                }
            }
        }
        .padding()
    }
}

struct PieceView: View {
    var index: Int
    var piece: Piece
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        Circle()
            .fill(self.piece.side == .white ? .white : .black)
            .overlay { Circle().stroke() }
            .padding(4)
    }
    init(_ index: Int, _ piece: Piece) {
        self.index = index
        self.piece = piece
    }
}
