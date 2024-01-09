import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: AppModel
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(1...8, id: \.self) { column in
                    VStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { row in
                            SquareView(index: column + row * 8)
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
        .padding(128)
        .glassBackgroundEffect()
        .rotation3DEffect(.init(angle: .degrees(90), axis: .x))
        .offset(y: (FixedValue.windowLength / 2) - FixedValue.toolbarHeight)
        .frame(width: FixedValue.windowLength, height: FixedValue.windowLength)
        .frame(depth: FixedValue.windowLength)
        .modifier(SideSelectionBar())
    }
}
