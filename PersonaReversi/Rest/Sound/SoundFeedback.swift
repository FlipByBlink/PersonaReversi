import SwiftUI
import AVFAudio

class SoundFeedback {
    private var crackPlayers: [AVAudioPlayer] = []
    private var resetPlayer: AVAudioPlayer?
    init() {
        Task(priority: .background) {
            try? AVAudioSession().setCategory(.ambient)
            self.crackPlayers = (1...6).compactMap {
                if let data = NSDataAsset(name: "sound\($0)")?.data,
                   let player = try? AVAudioPlayer(data: data) {
                    player.volume = 0.5
                    player.prepareToPlay()
                    return player
                } else {
                    assertionFailure()
                    return nil
                }
            }
            if let data = NSDataAsset(name: "resetSound")?.data,
               let player = try? AVAudioPlayer(data: data) {
                self.resetPlayer = player
                self.resetPlayer?.volume = 0.13
                self.resetPlayer?.prepareToPlay()
            } else {
                assertionFailure()
            }
        }
    }
    func play(_ file: SoundFile) {
        Task(priority: .background) {
            switch file {
                case .crack:
                    self.crackPlayers.randomElement()?.play()
                case .reset:
                    self.resetPlayer?.play()
            }
        }
    }
}
