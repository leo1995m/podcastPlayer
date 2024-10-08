//
//  PlayerMainViewController.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 11/09/24.
//

import UIKit
import AVFoundation

class PlayerManagerViewController: UIViewController {
    private var episodes: [EpisodeModel]
    private var selectedIndex: Int
    private var podcastFullPlayerIntance: PodcastFullPlayer?
    private var podcastminiPlayerIntance: MiniPlayerView?
    private var podcastImageUrl: String?
    
    init(episodes: [EpisodeModel], selectedIndex: Int, podcastImageUrl: String?) {
        self.episodes = episodes
        self.selectedIndex = selectedIndex
        self.podcastImageUrl = podcastImageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentFullPlayer(from parentVC: UIViewController, delegate: PodcastPlayerProtocol) {
        
        let podcastFullPlayerViewModel = PodcastFullPlayerViewModel(episodes: episodes, selectedIndex: selectedIndex, podcastImageUrl: podcastImageUrl)
        let podcastFullPlayer = PodcastFullPlayer(viewModel: podcastFullPlayerViewModel)
        podcastFullPlayer.configure()
        
        podcastFullPlayer.modalPresentationStyle = .pageSheet
        podcastFullPlayer.delegate = delegate
        if let sheet = podcastFullPlayer.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        podcastFullPlayerIntance = podcastFullPlayer
        parentVC.present(podcastFullPlayer, animated: true, completion: nil)
    }
    
    func presentFullFromMiniPlayer(from parentVC: UIViewController) {
        guard let podcastFullPlayerIntance else { return }
        parentVC.present(podcastFullPlayerIntance, animated: true, completion: nil)
    }
    
    func showMiniPlayer(delegate: MiniPlayerProtocol, currentEpisode: EpisodeModel, isPlaying: Bool, image: UIImage) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                let window = windowScene.windows.first else {
              return
          }
            
            let miniPlayerViewModel = MiniPlayerViewModel(currentEpisode: currentEpisode, isPlaying: isPlaying, image: image)
            let miniPlayer = MiniPlayerView(viewModel: miniPlayerViewModel, frame: CGRect(x: 0, y: window.bounds.height - 100, width: window.bounds.width, height: 80))
            
            miniPlayer.delegate = delegate
            miniPlayer.configure()
            window.addSubview(miniPlayer)
        }
    }



