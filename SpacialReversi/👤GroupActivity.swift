import GroupActivities
import SwiftUI

struct 👤GroupActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = String(localized: "Reversi")
        metadata.type = .generic
        return metadata
    }
}

extension 👤GroupActivity: Transferable {}
