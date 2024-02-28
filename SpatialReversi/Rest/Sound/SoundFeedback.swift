import SwiftUI
import AVFAudio

class SoundFeedback {
    private var crackPlayers: [AVAudioPlayer] = []
    private var resetPlayer: AVAudioPlayer?
    init() {
        Task(priority: .background) {
            try? AVAudioSession().setCategory(.ambient)
            self.crackPlayers = (1...6).compactMap {
                if let ⓓata = NSDataAsset(name: "sound\($0)")?.data,
                   let ⓟlayer = try? AVAudioPlayer(data: ⓓata) {
                    ⓟlayer.volume = 0.5
                    ⓟlayer.prepareToPlay()
                    return ⓟlayer
                } else {
                    assertionFailure()
                    return nil
                }
            }
            if let ⓓata = NSDataAsset(name: "resetSound")?.data,
               let ⓟlayer = try? AVAudioPlayer(data: ⓓata) {
                self.resetPlayer = ⓟlayer
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
