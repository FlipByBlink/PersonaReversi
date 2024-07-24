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
                    NavigationLink("What's Persona?") { Self.whatsPersonaMenu() }
                }
                Section {
                    if self.isEligibleForGroupSession {
                        Text("You are currently connected with a friend. Join an activity launched by your friend, or launch an activity by yourself.")
                        Text("If your friend has already started reversi activity, you can join the activity from the Control Center.")
                    }
                }
                Section {
                    NavigationLink("Set up SharePlay") { self.setUpMenu() }
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
            let url = URL(string: "https://support.apple.com/guide/apple-vision-pro/use-shareplay-in-facetime-calls-tan15b2c7bf9/1.0/visionos/1.0")!
            Section {
                Link(destination: url) {
                    Text(verbatim: #"“Use SharePlay in FaceTime calls on Apple Vision Pro - Apple Support”"#)
                }
            } header: {
                Text("Apple official support page")
            } footer: {
                Text(verbatim: "\(url)")
            }
            Section {
                Text("The Group Activities framework uses end-to-end encryption on all session data. Developer and Apple doesn’t have the keys to decrypt this data.")
            } header: {
                Text("About data")
            }
        }
        .navigationTitle("What's SharePlay?")
    }
    private static func whatsPersonaMenu() -> some View {
        List {
            Text("The Persona (or Spatial Persona) is displayed as part of SharePlay, in collaboration with this app and FaceTime.")
            let url1 = URL(string: "https://support.apple.com/guide/apple-vision-pro/use-spatial-persona-tana1ea03f18/visionos")!
            Section {
                Link(destination: url1) {
                    Text(verbatim: #""Use spatial Persona (beta) on Apple Vision Pro - Apple Support”"#)
                }
            } header: {
                Text("Apple official support page")
            } footer: {
                Text(verbatim: "\(url1)")
            }
            let url2 = URL(string: "https://support.apple.com/guide/apple-vision-pro/capture-your-persona-beta-dev934d40a17/1.0/visionos/1.0")!
            Section {
                Link(destination: url2) {
                    Text(verbatim: #"“Capture and edit your Persona (beta) on Apple Vision Pro - Apple Support”"#)
                }
            } footer: {
                Text(verbatim: "\(url2)")
            }
        }
        .navigationTitle("What's Persona?")
    }
    private func setUpMenu() -> some View {
        List {
            Section {
                Text("If you launch this application during FaceTime, you can start an activity. When you start an activity, the callers automatically join an activity.")
                Button {
                    self.model.activateGroupActivity()
                } label: {
                    Label(#"Start "Share reversi" activity"#, systemImage: "play.fill")
                        .fontWeight(.semibold)
                }
                .disabled(!self.groupStateObserver.isEligibleForGroupSession)
            } header: {
                Text("How to start")
            }
            Section {
                Text("During a FaceTime call, a system menu UI for SharePlay appears at the bottom of the app. You can start SharePlay from the menu.")
            }
            Section {
                Text("If you want to join a SharePlay session that has already started, you can do so from the Control Center.")
            } header: {
                Text("Join SharePlay")
            }
        }
    }
}
