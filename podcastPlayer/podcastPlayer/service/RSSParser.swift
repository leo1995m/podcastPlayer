//
//  RSSParser.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation
import FeedKit

class RSSParser {
    func parseFeed(url: String, completion: @escaping (PodcastModel?) -> Void) {
        guard let feedUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                guard let rssFeed = feed.rssFeed else {
                    completion(nil)
                    return
                }
                
                let episodes = rssFeed.items?.compactMap { item in
                    
                    EpisodeModel(title: item.title,
                                 imageURL: item.iTunes?.iTunesImage?.attributes?.href,
                                 description: item.description,
                                 author: item.author,
                                 duration: TimeInterval(item.iTunes?.iTunesDuration ?? 0),
                                 audioURL: item.enclosure?.attributes?.url)
                    
                } ?? []
                
                
                let podcast = PodcastModel(title: rssFeed.title,
                                           image: rssFeed.image?.url,
                                           description: rssFeed.description,
                                           iTunesCategories: rssFeed.iTunes?.iTunesCategories,
                                           episodes: episodes)
                completion(podcast)
                
            case .failure(let error):
                print("error parsing feed: \(error)")
                completion(nil)
            }
        }
    }
}
