//
//  PodcastEntreViewModel.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation

class PodcastEnterViewModel {
    
    private let historyKey = "PodcastUrlHistory"
    let historyLimit: Int
    var podcast: PodcastModel?
    
    var urlHistory: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: historyKey) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: historyKey)
        }
    }
    
    init(historyLimit: Int = 3) {
        self.historyLimit = historyLimit
    }
    
    func addUrlToHistory(_ url: String) {
        var history = urlHistory
        
        if history.contains(url) {
            return
        }
        
        if history.count >= historyLimit {
            history.removeLast()
        }
        
        history.insert(url, at: 0)
        urlHistory = history
    }
    
    func getUrl(at index: Int) -> String? {
        guard index < urlHistory.count else { return nil }
        return urlHistory[index]
    }
    

    func fetchPodcasts(url: String, completion: @escaping (Bool) -> Void) {
        let service = PodcastService()
        service.fetchPodcast(url: url) { [weak self] podcast in
            guard let podcast = podcast else {
               completion(false)
                return
            }
            self?.podcast = podcast
            completion(true)
        }
    }
}
