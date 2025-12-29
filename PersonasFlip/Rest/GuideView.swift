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
                    NavigationLink("Set up SharePlay") { self.setUpMenu() }
                }
            }
            .font(.title3)
            .navigationTitle("PersonasFlip")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
            .safeAreaInset(edge: .bottom) {
                if self.groupStateObserver.isEligibleForGroupSession {
                    self.startActivityButton()
                        .padding(24)
                }
            }
        }
        .frame(width: 800, height: 800)
        .glassBackgroundEffect()
        .opacity(self.model.groupSession == nil ? 1 : 0)
        .animation(.default, value: self.model.groupSession == nil)
        .animation(.default, value: self.groupStateObserver.isEligibleForGroupSession)
        .offset(z: -(Size.board / 2))
    }
}

private extension GuideView {
    private static func whatsSharePlayMenu() -> some View {
        List {
            Section {
                Image(.exampleSharePlay)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
                    .clipShape(.rect(cornerRadius: 10))
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)
            }
            Section {
                Text("With SharePlay in the FaceTime app, you can play game in sync with friends and family while on a FaceTime call together. Enjoy a real-time connection with others on the call—with synced game and shared controls, you see and hear the same moments at the same time.")
                Text("In visionOS 26, You can share spatial experiences with other Apple Vision Pro users in the same room.")
            }
            Self.linkSection(
                url: "https://support.apple.com/guide/apple-vision-pro/tan15b2c7bf9/visionos",
                title: #"“Use SharePlay in FaceTime calls on Apple Vision Pro - Apple Support”"#
            )
            Self.linkSection(
                url: "https://support.apple.com/guide/apple-vision-pro/tanbccb085c1/visionos",
                title: #"“Share apps and experiences with people nearby on Apple Vision Pro - Apple Support”"#,
                hasHeader: false
            )
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
            Section {
                Image(.exampleSpatialPersonas)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400)
                    .clipShape(.rect(cornerRadius: 10))
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)
            }
            Self.linkSection(
                url: "https://support.apple.com/guide/apple-vision-pro/use-spatial-persona-tana1ea03f18/visionos",
                title: #""Use spatial Persona on Apple Vision Pro - Apple Support”"#
            )
            Self.linkSection(
                url: "https://support.apple.com/guide/apple-vision-pro/dev934d40a17/visionos",
                title: #"“Capture and edit your Persona on Apple Vision Pro - Apple Support”"#,
                hasHeader: false
            )
        }
        .navigationTitle("What's Persona?")
    }
    private static func linkSection(url: String,
                                    title: LocalizedStringResource,
                                    hasHeader: Bool = true) -> some View {
        Section {
            Link(destination: URL(string: url)!) {
                Text(title)
            }
            .foregroundStyle(.link)
        } header: {
            Text("Apple official support page")
        } footer: {
            Text(verbatim: "\(url)")
        }
    }
    private func setUpMenu() -> some View {
        List {
            Section {
                Text("If you launch this application during FaceTime, you can start an activity. When you start an activity, the callers automatically join an activity.")
                if self.groupStateObserver.isEligibleForGroupSession {
                    self.startActivityButton()
                }
            } header: {
                Text("How to start")
            }
            Section {
                VStack(spacing: 16) {
                    Text("You can start SharePlay from a system menu UI, which is located at the bottom of the app.")
                    Image(.bottomSystemUI)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400)
                        .clipShape(.rect(cornerRadius: 16))
                }
            }
            Section {
                Text("If you want to join a SharePlay session that has already started, you can do so from the Control Center.")
            } header: {
                Text("Join SharePlay")
            }
        }
    }
    private func startActivityButton() -> some View {
        Button {
            self.model.activateGroupActivity()
        } label: {
            Label(#"Start "Play game" activity"#, systemImage: "play.fill")
                .fontWeight(.semibold)
        }
    }
}
