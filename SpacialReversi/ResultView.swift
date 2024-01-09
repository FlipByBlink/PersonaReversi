import SwiftUI

struct ResultEffect: ViewModifier {
    @EnvironmentObject var model: AppModel
    func body(content: Content) -> some View {
        content
            .overlay {
                if self.model.presentResult {
                    VStack(spacing: 48) {
                        HStack(spacing: 32) {
                            Color.white.clipShape(.circle)
                                .frame(width: 80, height: 80)
                            Text("White")
                            Spacer()
                            Text("\(self.model.pieces.pieceCounts[.white] ?? 0)")
                                .fontWeight(.heavy)
                        }
                        HStack(spacing: 32) {
                            Color.black.clipShape(.circle)
                                .frame(width: 80, height: 80)
                            Text("Black")
                            Spacer()
                            Text("\(self.model.pieces.pieceCounts[.black] ?? 0)")
                                .fontWeight(.heavy)
                        }
                    }
                    .font(.system(size: 60))
                    .padding(64)
                    .frame(width: 600)
                    .glassBackgroundEffect()
                    .offset(z: -FixedValue.windowLength / 2)
                }
            }
    }
}
