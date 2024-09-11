//
//  CacheManager.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation

class CacheManager {
    
    private let maxCacheSize: Int64 = 1000 * 1024 * 1024
    
    private func getCacheDirectory() -> URL? {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let cacheDirectory = documentsPath.appendingPathComponent("podcastCache")
        
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error.localizedDescription)")
                return nil
            }
        }
        
        return cacheDirectory
    }
    
    func getCachedPodcastURL(url: String) -> URL? {
        guard let cacheDirectory = getCacheDirectory(),
              let fileUrl = URL(string: url)?.lastPathComponent else {
            return nil
        }
        
        let podcastFileUrl = cacheDirectory.appendingPathComponent(fileUrl)
        
        return FileManager.default.fileExists(atPath: podcastFileUrl.path) ? podcastFileUrl : nil
    }
    
    func downloadAndCachePodcast(url: String, completion: @escaping (URL?) -> Void) {
        guard let podcastUrl = URL(string: url) else {
            completion(nil)
            return
        }
        clearOldFilesIfNeeded()
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: podcastUrl) { (location, response, error) in
            
            guard let location = location, error == nil,
                  let cacheDirectory = self.getCacheDirectory() else {
                print("Error downloading podcast: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let destinationURL = cacheDirectory.appendingPathComponent(podcastUrl.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                completion(destinationURL)
                return
            }
            
            do {
                try FileManager.default.moveItem(at: location, to: destinationURL)
                completion(destinationURL)
            } catch {
                print("Error moving file: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        downloadTask.resume()
    }
    
    private func getCacheSize() -> Int64 {
          guard let cacheDirectory = getCacheDirectory() else { return 0 }
          do {
              let files = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey], options: [])
              return files.reduce(0) { (total, file) -> Int64 in
                  let fileSize = (try? file.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
                  return total + Int64(fileSize)
              }
          } catch {
              print("Error getting cache size: \(error.localizedDescription)")
              return 0
          }
      }
      
      private func clearOldFilesIfNeeded() {
          guard getCacheSize() > maxCacheSize, let cacheDirectory = getCacheDirectory() else { return }
          
          do {
              let files = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.contentModificationDateKey], options: [])
              
              let sortedFiles = files.sorted {
                  let date1 = (try? $0.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                  let date2 = (try? $1.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast
                  return date1 < date2
              }
              
              var currentCacheSize = getCacheSize()
              for file in sortedFiles {
                  if currentCacheSize <= maxCacheSize {
                      break
                  }
                  let fileSize = (try? file.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
                  try FileManager.default.removeItem(at: file)
                  currentCacheSize -= Int64(fileSize)
              }
          } catch {
              print("Error clearing old files: \(error.localizedDescription)")
          }
      }

    
    func clearCache(completion: @escaping (Bool) -> Void) {
        guard let cacheDirectory = getCacheDirectory() else {
            completion(false)
            return
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
            completion(true)
        } catch {
            print("Error clearing cache: \(error.localizedDescription)")
            completion(false)
        }
    }
}
