//
//  MiniPlayerViewModel.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//

import Foundation
import UIKit
import AVFoundation

class MiniPlayerViewModel {
    var currentEpisode: EpisodeModel
    var player: AVPlayer? = AudioPlayerManager.shared.player
    var isPlaying: Bool
    var image: UIImage
    
    init(currentEpisode: EpisodeModel, isPlaying: Bool, image: UIImage) {
        self.currentEpisode = currentEpisode
        self.isPlaying = isPlaying
        self.image = image
    }
    
}
