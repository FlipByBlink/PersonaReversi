import GroupActivities
import SwiftUI

struct 👤GroupActivity: GroupActivity {
    var metadata: GroupActivityMetadata {
        var value = GroupActivityMetadata()
        value.title = String(localized: "Share reversi")
        value.type = .generic
        value.previewImage = UIImage(resource: .whole).cgImage
        return value
    }
}
