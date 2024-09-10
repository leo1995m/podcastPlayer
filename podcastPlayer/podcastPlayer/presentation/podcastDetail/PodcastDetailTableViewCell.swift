//
//  PodcastDetailTableViewCell.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 09/09/24.
//

import Foundation
import UIKit

class PodcastDetailTableViewCell: UITableViewCell {
    private var episode: EpisodeModel?
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 3
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var podcastInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var episodeImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var topStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    private lazy var infoStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 3
        return view
    }()
    
    private lazy var episodeInfoStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 8
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupMainStack()
        setupTopStack()
        setupInfoStack()
        setupEpisodeInfoStack()
        contentView.addSubview(mainStack)
    }
    
    private func setupEpisodeInfoStack() {
        episodeInfoStack.addArrangedSubview(podcastInfoLabel)
        
    }
    private func setupMainStack() {
        mainStack.addArrangedSubview(topStack)
        mainStack.addArrangedSubview(episodeInfoStack)
    }
    
    private func setupInfoStack() {
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(descriptionLabel)
    }
    
    private func setupTopStack() {
        topStack.addArrangedSubview(episodeImage)
        topStack.addArrangedSubview(infoStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            episodeImage.heightAnchor.constraint(equalToConstant: 100),
            episodeImage.widthAnchor.constraint(equalToConstant: 100),
            
        ])
    }
    
    func configure(with episode: EpisodeModel) {
        self.episode = episode
        titleLabel.text = episode.title
        descriptionLabel.text = episode.description?.removeHTMLTags
        podcastInfoLabel.text = formatInfoLabel()
        if let imageUrlString = episode.imageURL,
           let imageUrl = URL(string: imageUrlString) {
            episodeImage.cachedImage(url: imageUrl)
        } else {
            episodeImage.isHidden = true
        }
    }
    
    private func formatInfoLabel() -> String {
        var label = ""
        if let author = episode?.author {
            label = label + "\(author) • "
        }
        if let duration = episode?.duration {
            label = label + duration.formatTimeInterval()
        }
        return label
    }
    
}




