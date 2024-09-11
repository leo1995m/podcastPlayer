//
//  AudioPlayerManager.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 11/09/24.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var player: AVPlayer?
    
    private init() {}
    
    func initializePlayer(with url: URL) {
        if player == nil {
            player = AVPlayer(url: url)
        }
    }
    
    func isPlayerInitialized() -> Bool {
        return player != nil
    }
    
    func replaceCurrentPlayerItem(with url: URL) {
        let newPlayerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: newPlayerItem)
    }
}
