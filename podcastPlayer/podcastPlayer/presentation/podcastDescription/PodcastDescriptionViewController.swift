//
//  PodcastDescriptionViewController.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 10/09/24.
//

import Foundation
import UIKit

class PodcastDescriptionViewController: UIViewController {
    
    private let viewModel: PodcastDescriptionViewModel
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fullDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: PodcastDescriptionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(fullDescription)
        view.addSubview(closeButton)
        
        titleLabel.text = viewModel.podcastTitle
        fullDescription.text = viewModel.podcastDescription
        
        setupConstraints()
        
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            fullDescription.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            fullDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
        ])
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
}
