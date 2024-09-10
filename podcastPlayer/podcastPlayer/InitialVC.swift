//
//  InitialVC.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation
import UIKit

class InitialVC: UIViewController {
    private var url: String = "sem url"
    
    private lazy var label = {
        let label = UILabel()
        label.text = "no more storyboards"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label.text = url
        setupView()
    }
    
    func setupView() {
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
