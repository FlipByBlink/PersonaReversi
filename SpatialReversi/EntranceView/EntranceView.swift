import SwiftUI
import GroupActivities

struct EntranceView: View {
    @EnvironmentObject var model: 🥽AppModel
    @StateObject private var groupStateObserver = GroupStateObserver()
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
                                    .frame(width: 360)
                                Text("With SharePlay in the FaceTime app, you can play reversi in sync with friends and family while on a FaceTime call together. Enjoy a real-time connection with others on the call—with synced game and shared controls, you see and hear the same moments at the same time.")
                                //"With SharePlay in the FaceTime app, you can stream TV shows, movies, and music in sync with friends and family while on a FaceTime call together. Enjoy a real-time connection with others on the call—with synced playback and shared controls, you see and hear the same moments at the same time."
                            }
                            .padding()
                        }
                        .navigationTitle("What's SharePlay?")
                    }
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
                            }
                            Section {
                                Button("Start activity!") {
                                    self.model.activateGroupActivity()
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
                }
                if self.model.groupSession?.state != nil {
                    Section { self.groupSessionStateText() }
                }
            }
            .navigationTitle("SpatialReversi")
        }
        .frame(width: 800, height: 600)
        .glassBackgroundEffect()
        .opacity(self.model.showEntrance ? 1 : 0)
        .animation(.default, value: self.model.showEntrance)
        .offset(y: -2850)
        .offset(z: -1100)
    }
}

private extension EntranceView {
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
