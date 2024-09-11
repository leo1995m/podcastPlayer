//
//  MiniPlayerView.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//

import UIKit

protocol MiniPlayerProtocol: AnyObject {
    func didTapMiniPlayer()
}

final class MiniPlayerView: UIView {
    
    weak var delegate: MiniPlayerProtocol?
    private var viewModel: MiniPlayerViewModel
    
    private lazy var podcastImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var podcastTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        return button
    }()
    
    init(viewModel: MiniPlayerViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMiniPlayer)))
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(podcastImageView)
        addSubview(podcastTitleLabel)
        addSubview(playPauseButton)
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            podcastImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            podcastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            podcastImageView.widthAnchor.constraint(equalToConstant: 40),
            podcastImageView.heightAnchor.constraint(equalToConstant: 40),
            
            podcastTitleLabel.leadingAnchor.constraint(equalTo: podcastImageView.trailingAnchor, constant: 8),
            podcastTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            podcastTitleLabel.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -8),
            
            playPauseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 30),
            playPauseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func didTapMiniPlayer() {
        delegate?.didTapMiniPlayer()
    }
    

    func configure() {
        podcastImageView.image = viewModel.image
        podcastTitleLabel.text = viewModel.currentEpisode.title
        playPauseButton.setImage(UIImage(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill"), for: .normal)
    }
    
    @objc private func didTapPlayPause() {
        let pause = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        let play = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        
        if viewModel.isPlaying {
            viewModel.player?.pause()
            viewModel.isPlaying = false
            playPauseButton.setImage(play, for: .normal)
        } else {
            viewModel.player?.play()
            viewModel.isPlaying = true
            playPauseButton.setImage(pause, for: .normal)
        }
    }
}
