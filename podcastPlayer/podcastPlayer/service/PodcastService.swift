//
//  PodcastService.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation

class PodcastService {
    let parser = RSSParser()
    let cacheManager = CacheManager()
    
    func fetchPodcast(url: String, completion: @escaping (PodcastModel?) -> Void) {
        parser.parseFeed(url: url, completion: completion)
    }
}
