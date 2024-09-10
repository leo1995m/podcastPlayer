//
//  PodcastEnterScreen.swift
//  podcastPlayer
//
//  Created by Leonardo Moraes on 08/09/24.
//

import Foundation
import UIKit

class PodcastEnterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel: PodcastEnterViewModel
    
    private lazy var podcastImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "play.house.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Insira a URL do podcast:"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Digite a URL do podcast"
        textField.keyboardType = .URL
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continuar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ultimos vistos:"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemBlue
        return activityIndicator
    }()
    
    
    init(viewModel: PodcastEnterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupLoadingIndicator()
        setupTableView()
        setupView()
        setupConstraints()
    }
    
    private func setupLoadingIndicator(){
        loadingView.center = view.center
        loadingView.hidesWhenStopped = true
    }
    
    private func setupTableView() {
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(PodcastEnterHistoryTableViewCell.self, forCellReuseIdentifier: "UrlHistoryCell")
    }
    
    private func setupView() {
        view.addSubview(podcastImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(urlTextField)
        view.addSubview(continueButton)
        view.addSubview(historyLabel)
        view.addSubview(historyTableView)
        view.addSubview(loadingView)
        
        if viewModel.urlHistory.count > 0 {
            historyLabel.isHidden = false
        } else {
            historyLabel.isHidden = true
        }
        
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            podcastImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            podcastImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
            podcastImageView.widthAnchor.constraint(equalToConstant: 80),
            podcastImageView.heightAnchor.constraint(equalToConstant: 80),
            
            descriptionLabel.topAnchor.constraint(equalTo: podcastImageView.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            urlTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            urlTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            urlTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            urlTextField.heightAnchor.constraint(equalToConstant: 40),
            
            continueButton.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 20),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            
            historyLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 30),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            historyTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 20),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func continueButtonTapped() {
        view.endEditing(true)
        
        guard let url = urlTextField.text, !url.isEmpty else {
            showAlert("Erro", "Por favor insira uma URL.")
            return
        }
        
        loadingView.startAnimating()
        
        viewModel.fetchPodcasts(url: url) { [weak self] success in
            
            DispatchQueue.main.async {
                self?.urlTextField.text = ""
                self?.loadingView.stopAnimating()
                
                if success {
                    self?.historyLabel.isHidden = false
                    self?.viewModel.addUrlToHistory(url)
                    self?.historyTableView.reloadData()
                    self?.navigateToNextPage()
                } else {
                    self?.showAlert("Atenção", "Por favor verifique a URL e tente novamente.")
                }
            }
        }
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    private func navigateToNextPage() {
        guard let podcast = viewModel.podcast else {
            return
        }
        let podcastDetailViewModel = PodcastDetailViewModel(podcast: podcast)
               let podcastDetailViewController = PodcastDetailViewController(viewModel: podcastDetailViewModel)
               navigationController?.pushViewController(podcastDetailViewController, animated: true)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.urlHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "UrlHistoryCell", for: indexPath) as? PodcastEnterHistoryTableViewCell else { return UITableViewCell() }
        
        let url = viewModel.urlHistory[indexPath.row]
        cell.configure(with: url)
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedUrl = viewModel.getUrl(at: indexPath.row) {
            loadingView.startAnimating()
            viewModel.fetchPodcasts(url: selectedUrl) { [weak self] success in
                
                DispatchQueue.main.async {
                    self?.loadingView.stopAnimating()
                    
                    if success {
                        self?.navigateToNextPage()
                    } else {
                        self?.showAlert("Aviso", "Ocorreu um erro ao carregar o podcast selecionado")
                    }
                }
            }
        }
    }
}
