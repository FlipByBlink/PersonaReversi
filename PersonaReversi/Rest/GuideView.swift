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
                }
                Section {
                    if self.isEligibleForGroupSession {
                        Text("You are currently connected with a friend. Join an activity launched by your friend, or launch an activity by yourself.")
                        Text("If your friend has already started reversi activity, you can join the activity by manipulating the system-side UI.")
                    }
                }
                Section {
                    NavigationLink("Set up SharePlay") { self.activityMenu() }
                }
            }
            .font(.title3)
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
        .frame(width: 1000, height: 700)
        .glassBackgroundEffect()
        .opacity(self.showGuide ? 1 : 0)
        .animation(.default, value: self.showGuide)
        .animation(.default, value: self.isEligibleForGroupSession)
        .offset(z: -(Size.board / 2))
    }
}

private extension GuideView {
    var showGuide: Bool {
#if targetEnvironment(simulator)
        true
//        false
#else
        self.model.groupSession == nil
#endif
    }
    var isEligibleForGroupSession: Bool {
#if targetEnvironment(simulator)
        true
//        false
#else
        self.groupStateObserver.isEligibleForGroupSession
#endif
    }
    private static func whatsSharePlayMenu() -> some View {
        List {
            HStack(spacing: 28) {
                Image(.exampleSharePlay)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 460)
                Text("With SharePlay in the FaceTime app, you can play reversi in sync with friends and family while on a FaceTime call together. Enjoy a real-time connection with others on the call—with synced game and shared controls, you see and hear the same moments at the same time.")
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
                Text("You can also start SharePlay yourself. Please manipulate the system-side UI.")
                Text("Once you have started an activity, encourage your friends to join SharePlay.")
            } header: {
                Text("Start SharePlay by oneself")
            }
        }
    }
}
