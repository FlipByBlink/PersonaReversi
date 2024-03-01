import SwiftUI
import GroupActivities

struct EntranceView: View {
    @EnvironmentObject var model: 🥽AppModel
    @StateObject private var groupStateObserver = GroupStateObserver()
    @Environment(\.physicalMetrics) var physicalMetrics
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("What's SharePlay?") {
                        List {
                            HStack(spacing: 24) {
                                Image(.exampleSharePlay)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 500)
                                Text("With SharePlay in the FaceTime app, you can play reversi in sync with friends and family while on a FaceTime call together. Enjoy a real-time connection with others on the call—with synced game and shared controls, you see and hear the same moments at the same time.")
                                    .font(.title)
                                //"With SharePlay in the FaceTime app, you can stream TV shows, movies, and music in sync with friends and family while on a FaceTime call together. Enjoy a real-time connection with others on the call—with synced playback and shared controls, you see and hear the same moments at the same time."
                            }
                            .padding()
                        }
                        .navigationTitle("What's SharePlay?")
                    }
                    .font(.system(size: 48))
                }
                Section {
                    NavigationLink("No activity?") {
                        List {
                            Section {
                                LabeledContent {
                                    Text("\(self.groupStateObserver.isEligibleForGroupSession.description)")
                                } label: {
                                    Text("Eligible for SharePlay:")
                                }
                                .font(.largeTitle)
                            }
                            Section {
                                Button {
                                    self.model.activateGroupActivity()
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "shareplay")
                                        Text("Start with SharePlay!")
                                    }
                                    .padding(.leading)
                                }
                                .font(.extraLargeTitle2)
                                .disabled(
                                    !self.groupStateObserver.isEligibleForGroupSession
                                    ||
                                    self.model.groupSession?.state != nil
                                )
                                //} footer: {
                                //    Text("If you launch this application during FaceTime, you can start an activity. When you launch an activity, the caller's device will show a notification asking them to join SharePlay.")
                            }
                        }
                    }
                    .font(.system(size: 48))
                }
                if self.model.groupSession?.state != nil {
                    Section { self.groupSessionStateText() }
                }
            }
            .navigationTitle("SpatialReversi")
        }
        .frame(width: 1000, height: 700)
        .glassBackgroundEffect()
        .animation(.default, value: self.model.showEntrance)
        .offset(y: -self.yOffset)
        .offset(z: -self.zOffset)
        .animation(.default, value: self.yOffset)
    }
}

private extension EntranceView {
    private var yOffset: CGFloat {
        600
        +
        self.physicalMetrics.convert(self.model.activityState.viewHeight.value, from: .meters)
    }
    private var zOffset: CGFloat {
        (Size.board / 2)
        +
        self.physicalMetrics.convert(Size.zOffsetInNonSpatial, from: .meters)
    }
    private func groupSessionStateText() -> some View {
        LabeledContent {
            Text({
                switch self.model.groupSession?.state {
                    case .waiting: "waiting"
                    case .joined: "joined"
                    case .invalidated(reason: let error): "invalidated(\(error.localizedDescription))"
                    case .none: "none"
                    @unknown default: "@unknown default"
                }
            }())
        } label: {
            Text("groupSession?.state:")
        }
    }
}
