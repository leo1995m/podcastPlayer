//
//  CacheManager.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation

class CacheManager {
    
    func getCachedPodcastURL(url: String) -> URL? {
        guard let fileUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return FileManager.default.fileExists(atPath: fileUrl.path) ? fileUrl : nil
    }
    
    func downloadAndCachePodcast(url: String, completion: @escaping (URL?) -> Void) {
        guard let podcastUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: podcastUrl) { (location, response, error) in
            
            guard let location = location, error == nil,
                  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completion(nil)
                return
            }
            
            let destinationURL = documentsPath.appendingPathComponent(podcastUrl.lastPathComponent)
            
            do {
                try FileManager.default.moveItem(at: location, to: destinationURL)
                completion(destinationURL)
            } catch {
                print("error moving file: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        downloadTask.resume()
    }
}
