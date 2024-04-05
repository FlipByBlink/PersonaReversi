import SwiftUI

struct ToolbarsView: View {
    var body: some View {
        ZStack {
            Self.ContentView()
                .offset(z: Size.toolbarOffset)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(90), axis: .y))
                .offset(x: Size.toolbarOffset)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(270), axis: .y))
                .offset(x: -Size.toolbarOffset)
            Self.ContentView()
                .rotation3DEffect(.init(angle: .degrees(180), axis: .y))
                .offset(z: -Size.toolbarOffset)
        }
        .offset(y: (Size.toolbarHeight / 2) + 24)
    }
}

private extension ToolbarsView {
    private struct ContentView: View {
        @EnvironmentObject var model: 🥽AppModel
        @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
        @State private var showSharePlaySubmenu: Bool = true
//        @State private var showSharePlaySubmenu: Bool = false //TODO: 戻す
        var body: some View {
            HStack(spacing: 24) {
                Button {
                    Task {
                        await self.dismissImmersiveSpace()
                    }
                } label: {
                    Label("Exit", systemImage: "escape")
                        .padding(16)
                        .font(.title)
                }
                .padding(12)
                .glassBackgroundEffect()
                .buttonStyle(.plain)
                HStack(spacing: 24) {
                    HStack(spacing: 20) {
                        ForEach([Side.white, .black], id: \.self) { side in
                            Button {
                                withAnimation(.default.speed(1.5)) {
                                    self.model.side = side
                                }
                            } label: {
                                Circle()
                                    .fill(side == .white ? .white : .black)
                                    .opacity(self.model.side == side ? 0.9 : 0.75)
                                    .shadow(color: .gray, radius: 2)
                                    .frame(width: 54, height: 54)
                                    .overlay {
                                        if self.model.side == side {
                                            Image(systemName: "checkmark")
                                                .font(.title.bold())
                                                .foregroundStyle(.green)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
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
                    .font(.title)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.plain)
                    Button {
                        self.model.reset()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .padding(12)
                            .minimumScaleFactor(0.5)
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                    if true { //TODO: 戻す
//                    if [.waiting, .joined].contains(self.model.groupSession?.state)  {
                        Button {
                            self.showSharePlaySubmenu.toggle()
                        } label: {
                            Image(systemName: "shareplay")
                                .padding()
                                .opacity(self.showSharePlaySubmenu ? 0 : 1)
                                .overlay {
                                    if self.model.groupSession?.state == .waiting {
                                        ProgressView()
                                    }
                                }
                                .overlay {
                                    if self.showSharePlaySubmenu {
                                        Image(systemName: "xmark.circle.fill")
                                            .imageScale(.large)
                                    }
                                }
                        }
                        .font(.title)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.plain)
                        .overlay(alignment: .top) {
                            if self.showSharePlaySubmenu {
                                VStack {
                                    HStack {
                                        Text("SharePlay state:")
                                        Spacer()
                                        Text("?")
                                            .foregroundStyle(.secondary)
                                    }
                                    .font(.subheadline)
                                    .padding(8)
                                    Divider()
                                    VStack {
                                        Button {
                                        } label: {
                                            Text("Leave the activity")
                                        }
                                        Text("Everyone remains in the activity except you.")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(8)
                                    Divider()
                                    VStack {
                                        Button("Close the activity") {}
                                        Text("Everyone will leave the activity.")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(8)
                                }
                                .padding(24)
                                .glassBackgroundEffect()
                                .frame(width: 640, height: 400, alignment: .bottom)
                                .offset(z: 30)
                                .offset(y: 30)
                                .alignmentGuide(.top) { $0.height }
                            }
                        }
                    }
                }
                .padding(12)
                .padding(.horizontal, 40)
                .frame(height: Size.toolbarHeight)
                .glassBackgroundEffect()
            }
            .animation(.default, value: self.model.groupSession?.state == .joined)
            .animation(.default, value: self.showSharePlaySubmenu)
            .rotation3DEffect(.degrees(20), axis: .x)
        }
    }
}
