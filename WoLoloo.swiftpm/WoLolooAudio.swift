import SwiftUI
import AVFoundation

struct WoLolooAudio {    
    private var player: AVAudioPlayer? = nil
    private var volume: Float = 0.25
    private var isMuted: Bool = false
    
    init() {
        
        if UserDefaults.standard.object(forKey: WoLolooSession.udk_volume) != nil {
            self.volume = UserDefaults.standard.float(forKey: WoLolooSession.udk_volume)   
        }
        if UserDefaults.standard.object(forKey: WoLolooSession.udk_muted) != nil {
            self.isMuted = UserDefaults.standard.bool(forKey: WoLolooSession.udk_muted)   
        }
        
        if let sound = Bundle.main.path(forResource: "WoLoloo-Call-PhoneFx", ofType: "m4a") {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            } catch {
                print("AVAudioPlayer could not be instantiated.")
            }
        } else {
            print("Audio file could not be found.")
        }
    }
    func getVolume() -> Float { return self.volume }
    func getIsMuted() -> Bool { return self.isMuted }
    
    mutating func setIsMuted(_ newIsMuted: Bool) {
        self.isMuted = newIsMuted
        UserDefaults.standard.set(newIsMuted, forKey: WoLolooSession.udk_muted)
    }
    mutating func setVolume(_ newVolume: Float) {
        self.volume = newVolume.clamped(to: 0...1.0)
        UserDefaults.standard.set(newVolume, forKey: WoLolooSession.udk_volume)
        self.player?.volume = isMuted ? 0.0 : self.volume
    }
    func play() {
        player?.volume = isMuted ? 0.0 : volume
        player?.currentTime = 0
        player?.play()
    }
}

struct WoLolooAudioControls: View {
    @Binding var target: WoLolooAudio
    
    var volumeDelta: Float = 0.05
    
    var body: some View {
        let vol = target.getVolume()
        let muted = target.getIsMuted()
        
        HStack {
            Group {
                Button(action: { target.setVolume(vol - volumeDelta) }, 
                       label: { Image(systemName: "speaker.minus.fill")                    .resizable().aspectRatio(contentMode: .fit)
                })
                Button(action: {
                    target.setIsMuted(!muted) 
                }, label: {
                    Image(systemName: getVolumeImageName())
                        .resizable().aspectRatio(contentMode: .fit)
                })
                Button(action: { target.setVolume(vol + volumeDelta) }, 
                       label: { Image(systemName: "speaker.plus.fill").resizable().aspectRatio(contentMode: .fit) })
                
            }
            .frame(width: 24)
            .padding(.horizontal, 4)
        }
        
    }
    
    func getVolumeImageName() -> String {
        let vol = target.getVolume()
        let muted = target.getIsMuted()
        
        var volSpeakerImage: String = "speaker.slash"
        if muted { volSpeakerImage = "speaker.slash" }
        else if vol >= 0.75 { volSpeakerImage = "speaker.wave.3" }
        else if vol >= 0.5 { volSpeakerImage =  "speaker.wave.2" }
        else if vol >= 0.25 { volSpeakerImage =  "speaker.wave.1" }
        else if vol > 0.0 { volSpeakerImage =  "speaker" }
        return volSpeakerImage
    }
    
}
struct WoLolooAudioView: View {
    @Binding var target: WoLolooAudio
    
    var body: some View {
        
        GroupBox(content: {
            HStack {
                let vol = target.getVolume()
                let muted = target.getIsMuted()
                let formatted = String(format: "%.0f", vol * 100) + "%"
                GridLabel(title: "Volume")
                if muted { Text(formatted) } else { Image(systemName: "speaker.slash") }
                //                Text(!muted ? formatted : " / ")
                Spacer()                
                WoLolooAudioControls(target: $target)
            }.frame(maxWidth: .infinity)
        })
    }
}

