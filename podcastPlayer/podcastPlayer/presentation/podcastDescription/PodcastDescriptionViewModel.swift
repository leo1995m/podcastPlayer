//
//  PodcastDescriptionViewModel.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//

import Foundation

class PodcastDescriptionViewModel {
    
    var podcastTitle: String?
    var podcastDescription: String?
    
    init(podcastTitle: String, podcastDescription: String) {
        self.podcastTitle = podcastTitle
        self.podcastDescription = podcastDescription
    }
    
    
}
