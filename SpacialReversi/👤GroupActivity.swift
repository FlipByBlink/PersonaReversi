import GroupActivities
import SwiftUI

struct 👤GroupActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()
        metadata.title = String(localized: "⚪︎×Game")
        metadata.type = .generic
        //metadata.sceneAssociationBehavior = .content("document-1")
        return metadata
    }
}

extension 👤GroupActivity: Transferable {}
