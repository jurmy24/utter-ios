//
//  AudioManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import Foundation
import AVKit

class AudioManager {
    
    static let shared = AudioManager()
    
    var player: AVAudioPlayer?
    
    func playAudio(data: Data) {
        do {
            player = try AVAudioPlayer(data: data)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        player?.stop()
        player = nil
    }
}
