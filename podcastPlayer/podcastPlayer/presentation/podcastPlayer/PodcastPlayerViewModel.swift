//
//  PodcastPlayerViewModel.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//

import Foundation
import AVFoundation

class PodcastFullPlayerViewModel {
    let episodes: [EpisodeModel]
    let service = PodcastService()
    var selectedIndex: Int
    var currentEpisode: EpisodeModel
    var isPlaying: Bool = true
    var player: AVPlayer? = AudioPlayerManager.shared.player
    var podcastImageUrl: String?
    
    init(episodes: [EpisodeModel], selectedIndex: Int, podcastImageUrl: String?) {
        self.episodes = episodes
        self.selectedIndex = selectedIndex
        self.podcastImageUrl = podcastImageUrl
        currentEpisode = episodes[selectedIndex]
    }
    
    func getCachedEpisodeURL() -> URL? {
        guard let audioUrl = currentEpisode.audioURL else { return nil}
        return service.cacheManager.getCachedPodcastURL(url: audioUrl)
    }
    
    func downloadEpisode(completion: @escaping (URL?) -> Void) {
        guard let audioUrl = currentEpisode.audioURL else { return }
        service.cacheManager.downloadAndCachePodcast(url: audioUrl, completion: completion)
    }
    
    func getCurrentTimeFormatted(currentTime: CMTime) -> String {
        
        let totalSeconds = CMTimeGetSeconds(currentTime)
        
        guard !(totalSeconds.isNaN || totalSeconds.isInfinite) else { return "00:00" }
        
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func getDuration(episode: EpisodeModel) -> String {
        guard let duration = episode.duration else { return "" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func canGoTonextEpisode() -> Bool {
        if selectedIndex < episodes.count - 1 {
            currentEpisode = episodes[selectedIndex + 1]
            selectedIndex += 1
            return true
        } else {
            print("Não há mais episódios.")
            return false
        }
    }
    
    func canGoToPreviousEpisode() -> Bool {
        if selectedIndex > 0 {
            selectedIndex -= 1
            currentEpisode = episodes[selectedIndex]
            return true
        } else {
            print("Já está no primeiro episódio.")
            return false
        }
    }
}
