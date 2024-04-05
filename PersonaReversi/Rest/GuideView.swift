import SwiftUI
import GroupActivities

struct GuideView: View {
    @EnvironmentObject var model: 🥽AppModel
    @StateObject private var groupStateObserver = GroupStateObserver()
    @Environment(\.physicalMetrics) var physicalMetrics
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("What's SharePlay?") { Self.whatsSharePlayMenu() }
                        .font(.system(size: 48))
                }
                Section {
                    NavigationLink("No activity?") { self.activityMenu() }
                        .font(.system(size: 48))
                }
                if self.groupStateObserver.isEligibleForGroupSession {
                    Text("You are currently connected with a friend. Join an activity launched by your friend, or launch an activity by yourself.")
                }
            }
            .navigationTitle("PersonaReversi")
            .toolbar {
                NavigationLink {
                    List { ℹ️AboutAppContent() }
                } label: {
                    Label("About App", systemImage: "info")
                        .padding(14)
                }
                .buttonBorderShape(.circle)
                .buttonStyle(.plain)
            }
        }
        .padding()
        .frame(width: 1000, height: 700)
        .glassBackgroundEffect()
        .opacity(self.model.showGuide ? 1 : 0)
        .animation(.default, value: self.model.showGuide)
        .offset(y: -self.yOffset)
        .offset(z: -self.zOffset)
        .animation(.default, value: self.yOffset)
    }
}

private extension GuideView {
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
    private static func whatsSharePlayMenu() -> some View {
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
            Section {
                Text("The Group Activities framework uses end-to-end encryption on all session data. Developer and Apple doesn’t have the keys to decrypt this data.")
            } header: {
                Text("About data")
            }
        }
        .navigationTitle("What's SharePlay?")
    }
    private func activityMenu() -> some View {
        List {
            Section {
                Text("If you launch this application during FaceTime, you can start an activity. When you launch an activity, the caller's device will show a notification asking them to join SharePlay.")
                LabeledContent {
                    Text("\(self.groupStateObserver.isEligibleForGroupSession)")
                } label: {
                    Text("Eligible for SharePlay:")
                }
            } header: {
                Text("How to start")
            }
            Section {
                Text(#"If your friend has already started "Reversi" activity, you can join the activity by manipulating the system-side UI."#)
            } header: {
                Text("Join SharePlay")
            }
            Section {
                Text("You can also start SharePlay yourself. Once you have started an activity, encourage your friends to join SharePlay.")
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
            } header: {
                Text("Start SharePlay by oneself")
            }
        }
    }
}
