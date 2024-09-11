//
//  PodcastDetailViewController.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 09/09/24.
//

import Foundation
import UIKit
import AVFoundation

class PodcastDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel: PodcastDetailViewModel
    private var playerManager: PlayerManagerViewController?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var episodesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    init(viewModel: PodcastDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = viewModel.podcast?.title
        setupTableView()
        setupView()
        setupConstraints()
    }
    
    
    private func setupTableView() {
        episodesTableView.rowHeight = UITableView.automaticDimension
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        episodesTableView.register(PodcastDetailTableViewCell.self, forCellReuseIdentifier: "podcastCell")
    }
    
    private func setupView() {
        view.addSubview(episodesTableView)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            episodesTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            episodesTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            episodesTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            episodesTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.podcast?.episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastDetailTableViewCell,
              let episodes = viewModel.podcast?.episodes else { return UITableViewCell() }
        
        let episode = episodes[indexPath.row]
        cell.configure(with: episode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let podcast = viewModel.podcast
            let headerView = PodcastHeaderView(imageUrl: podcast?.image ?? "", description: podcast?.description ?? "", category: podcast?.categoriesString ?? "", title: podcast?.title ?? "")
            headerView.delegate = self
            return headerView
        }
        return nil
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openFullPlayer(selectedIndex: indexPath.row)
    }
}

// MARK: - Extensions

extension PodcastDetailViewController {
    private func openFullPlayer(selectedIndex: Int) {
        guard let episodes = viewModel.podcast?.episodes else { return }
        playerManager = PlayerManagerViewController(episodes: episodes, selectedIndex: selectedIndex)
        playerManager?.presentFullPlayer(from: self, delegate: self)
    }
    
    private func openMiniPlayer(currentEpisode: EpisodeModel, isPlaying: Bool, image: UIImage) {
        playerManager?.showMiniPlayer(delegate: self, currentEpisode: currentEpisode, isPlaying: isPlaying, image: image)
    }
    
}

extension PodcastDetailViewController: PodcastHeaderViewProtocol {
    func didTapSeeMore(title: String, description: String) {
        
        let podcastDescriptionViewModel = PodcastDescriptionViewModel(podcastTitle: title, podcastDescription: description)
        let podcastDescriptionViewController = PodcastDescriptionViewController(viewModel: podcastDescriptionViewModel)
        podcastDescriptionViewController.modalPresentationStyle = .pageSheet
        
        present(podcastDescriptionViewController, animated: true, completion: nil)
    }
}

extension PodcastDetailViewController: PodcastPlayerProtocol {
  
    func didDismissView(currentEpisode: EpisodeModel, isPlaying: Bool, image: UIImage) {
        openMiniPlayer(currentEpisode: currentEpisode, isPlaying: isPlaying, image: image)
    }
}

extension PodcastDetailViewController: MiniPlayerProtocol {
    func didTapMiniPlayer() {
        playerManager?.presentFullFromMiniPlayer(from: self)
    }
}
