//
//  PodcastModel.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation

import Foundation
import FeedKit

struct PodcastModel {
    let title: String?
    let image: String?
    let description: String?
    let iTunesCategories: [ITunesCategory]?
    let episodes: [EpisodeModel]?
    
    var categoriesString: String? {
        guard let iTunesCategories else { return nil }
        let categoriesList = iTunesCategories.compactMap { $0.attributes?.text }
        return categoriesList.joined(separator: "-")
    }
}

