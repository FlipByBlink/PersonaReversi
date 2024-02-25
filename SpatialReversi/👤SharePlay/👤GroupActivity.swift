import GroupActivities
import SwiftUI

struct 👤GroupActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var value = GroupActivityMetadata()
        value.title = String(localized: "Reversi")
        value.type = .generic
        value.previewImage = UIImage(resource: .whole).cgImage
        return value
    }
}

extension 👤GroupActivity: Transferable {}
