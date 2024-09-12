//
//  PodcastHeaderView.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//


import Foundation
import UIKit

protocol PodcastHeaderViewProtocol: AnyObject {
    func didTapSeeMore(title: String, description: String)
}

final class PodcastHeaderView: UIView {
    
    weak var delegate: PodcastHeaderViewProtocol?
    private var podcastTitle: String = ""
    
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var podcastImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoriesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Ver Mais"
        label.textColor = .systemIndigo
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var fullText: String = ""
    
    init(imageUrl: String, description: String, category: String, title: String) {
        super.init(frame: .zero)
        podcastTitle = title
        fullText = description
        setupView()
        
        if let imageUrl = URL(string: imageUrl) {
            podcastImage.cachedImage(url: imageUrl)
        }
        
        label.text = description
        if description.numberOfLines() > 3 {
            addShowMoreOption()
        }
        
        categoriesLabel.text = category
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        container.addSubview(podcastImage)
        container.addSubview(categoriesLabel)
        container.addSubview(label)
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 300),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            
            podcastImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            podcastImage.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            podcastImage.widthAnchor.constraint(equalToConstant: 150),
            podcastImage.heightAnchor.constraint(equalToConstant: 150),
            
            categoriesLabel.topAnchor.constraint(equalTo: podcastImage.bottomAnchor, constant: 8),
            categoriesLabel.centerXAnchor.constraint(equalTo: podcastImage.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        ])
    }
    
    
    private func addShowMoreOption() {
        container.addSubview(showMoreLabel)
        
        NSLayoutConstraint.activate([
            showMoreLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            showMoreLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullText))
        showMoreLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showFullText() {
        delegate?.didTapSeeMore(title: podcastTitle,description: fullText)
    }
}

