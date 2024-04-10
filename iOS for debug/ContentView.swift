import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: 🥽AppModel
    var body: some View {
        VStack {
            BoardView()
            HStack {
                Picker("Side", selection: self.$model.side) {
                    Text("White").tag(Side.white)
                    Text("Black").tag(Side.black)
                }
                Button("reset") {
                    self.model.reset()
                }
            }
        }
        .task { self.model.configureGroupSessions() }
        .task {
//            try? await Task.sleep(for: .seconds(2))
//            self.model.setPiecesForDebug()
        }
        .task { 👤Registration.execute() }
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
                                .overlay(alignment: .bottomTrailing) {
                                    if self.model.puttable(index) {
                                        Text("hoverEffect")
                                            .font(.footnote)
                                            .foregroundStyle(.green)
                                    }
                                }
                                .onTapGesture {
                                    if self.model.puttable(index) {
                                        self.model.set(index)
                                    }
                                }
                                .overlay {
                                    if let piece = self.model.activityState.pieces[index] {
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
                if self.model.activityState.showResult {
                    Text("""
                    ⚫️ \(self.model.activityState.pieces.pieceCounts[.black] ?? 0)
                    ⚪️ \(self.model.activityState.pieces.pieceCounts[.white] ?? 0)
                    """)
                    .font(.system(size: 70).bold())
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
            .overlay {
                Group {
                    switch self.model.activityState.pieces[index]?.phase {
                        case .fadeIn: Text("fadeIn")
                        case .flip: Text("flip")
                        case .slideDown: Text("down")
                        case .slideUp: Text("up")
                        default: EmptyView()
                    }
                }
                .font(.footnote)
                .foregroundStyle(.green)
            }
            .padding(4)
    }
    init(_ index: Int, _ piece: Piece) {
        self.index = index
        self.piece = piece
    }
}
