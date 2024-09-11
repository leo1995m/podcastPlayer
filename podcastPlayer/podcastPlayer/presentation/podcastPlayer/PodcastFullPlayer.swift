//
//  FullPlayer.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 11/09/24.
//

import Foundation
import UIKit
import AVFoundation


protocol PodcastPlayerProtocol: AnyObject {
    func didDismissView(currentEpisode: EpisodeModel, isPlaying: Bool, image: UIImage)
}

class PodcastFullPlayer: UIViewController, UISheetPresentationControllerDelegate {
    
    private var viewModel: PodcastFullPlayerViewModel
    
    weak var delegate: PodcastPlayerProtocol?
   
    
    private lazy var podCastImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var podcastTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        let image = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var controlsStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 8
        return view
    }()
    
    private lazy var sliderAndTimeStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 3
        return view
    }()
    
    private lazy var durantionStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 8
        return view
    }()
    
    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var durantionTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        return slider
    }()
    
    init(viewModel: PodcastFullPlayerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(didTapNext), name: .AVPlayerItemDidPlayToEndTime, object: viewModel.player?.currentItem)
        setupPlayerControlStack()
        setupDurantionStack()
        setupSliderAndTimeStack()
        
        setupViews()
        setupConstraints()
        
    sheetPresentationController?.delegate = self
    }
    
    
    private func setupPlayerControlStack() {
        controlsStack.addArrangedSubview(backButton)
        controlsStack.addArrangedSubview(playPauseButton)
        controlsStack.addArrangedSubview(nextButton)
    }
    
    private func setupDurantionStack() {
        durantionStack.addArrangedSubview(currentTimeLabel)
        durantionStack.addArrangedSubview(durantionTimeLabel)
    }
    
    private func setupSliderAndTimeStack() {
        sliderAndTimeStack.addArrangedSubview(progressSlider)
        sliderAndTimeStack.addArrangedSubview(durantionStack)
    }
    
    private func setupViews() {
        view.addSubview(podCastImageView)
        view.addSubview(podcastTitleLabel)
        view.addSubview(sliderAndTimeStack)
        view.addSubview(controlsStack)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            podCastImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            podCastImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            podCastImageView.widthAnchor.constraint(equalToConstant: 300),
            podCastImageView.heightAnchor.constraint(equalToConstant: 300),
            
            
            podcastTitleLabel.topAnchor.constraint(equalTo: podCastImageView.bottomAnchor, constant: 80),
            podcastTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            podcastTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            sliderAndTimeStack.topAnchor.constraint(equalTo: podcastTitleLabel.bottomAnchor, constant: 50),
            sliderAndTimeStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sliderAndTimeStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            controlsStack.topAnchor.constraint(equalTo: sliderAndTimeStack.bottomAnchor, constant: 50),
            controlsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            controlsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
            
        ])
    }
    
    func configure() {
        let currentEpisode = viewModel.currentEpisode
        podcastTitleLabel.text = currentEpisode.title
        durantionTimeLabel.text = viewModel.getDuration(episode: currentEpisode)
        
        if let imageUrlString = currentEpisode.imageURL,
           let imageURL = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.podCastImageView.image = image
                    }
                } else {
                    self.podCastImageView.isHidden = true
                }
            }
        }
    
                if let cachedURL = viewModel.getCachedEpisodeURL() {
                    setPlayerUrl(url: cachedURL)
                } else {
                    viewModel.downloadEpisode { [weak self] url in
                        DispatchQueue.main.async {
                            guard let url = url else { return }
                            self?.setPlayerUrl(url: url)
                        }
                    }
                }
        
        viewModel.player?.play()
        playPauseButton.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
        
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        viewModel.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateSliderProgress(episode: currentEpisode)
        }
    }
    
    private func setPlayerUrl(url: URL) {
        if AudioPlayerManager.shared.isPlayerInitialized() {
            AudioPlayerManager.shared.replaceCurrentPlayerItem(with: url)
        } else {
            AudioPlayerManager.shared.initializePlayer(with: url)
        }
        viewModel.player = AudioPlayerManager.shared.player
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
    
    @objc private func didTapNext() {
        if viewModel.canGoTonextEpisode() {
            nextButton.isEnabled = true
            configure()
        } else {
            nextButton.isEnabled = false
        }
    }
    
    @objc private func didTapBack() {
        if viewModel.canGoToPreviousEpisode() {
            configure()
        } else {
            restartEpisode()
        }
    }
    
    private func restartEpisode() {
        viewModel.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1)) { [weak self] completed in
            if completed {
                self?.viewModel.player?.play()
            }
        }
    }
    
    private func updateSliderProgress(episode: EpisodeModel) {
        guard let player = viewModel.player, let duration = episode.duration else { return }
        
        let currentTime = player.currentTime().seconds
        currentTimeLabel.text = viewModel.getCurrentTimeFormatted(currentTime: player.currentTime())
        progressSlider.value = Float(currentTime / duration)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        guard let duration = viewModel.player?.currentItem?.duration.seconds else { return }
        let newTime = CMTime(seconds: Double(sender.value) * duration, preferredTimescale: 1)
        
        viewModel.player?.seek(to: newTime)
    }
    
    private func updateSliderMaxValue() {
        guard let duration = viewModel.player?.currentItem?.duration.seconds else { return }
        progressSlider.maximumValue = Float(duration)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        delegate?.didDismissView(currentEpisode: viewModel.currentEpisode, isPlaying: viewModel.isPlaying, image: podCastImageView.image ?? UIImage())
    }
}
