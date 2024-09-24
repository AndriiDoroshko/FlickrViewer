//
//  DetailsViewController.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let publishedDateLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var viewModel: DetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        addCloseButton()
        updateViews()
    }
    
    private func addCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(closeButtonTapped))

        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFit
        imageView.addRefreshControl(activityIndicator)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authorLabel)

        publishedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(publishedDateLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            publishedDateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            publishedDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            publishedDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func updateViews() {
        guard let viewModel = viewModel else { return }
        
        let title = viewModel.flickrItem.title
        imageView.image = viewModel.image
        titleLabel.text = viewModel.flickrItem.title
        descriptionLabel.text = viewModel.flickrItem.description
        authorLabel.text = viewModel.flickrItem.author
        
        // Format the published date
        if let date = self.formatDate(viewModel.flickrItem.published) {
            publishedDateLabel.text = date
        }
        
        setNeedsFocusUpdate()
    }
    
    private func formatDate(_ dateString: String) -> String? {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .none
            return displayFormatter.string(from: date)
        }
        return nil
    }
}

extension DetailsViewController: DetailsViewModelDelegate {
    func displayError(_ message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
           
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController,
                          animated: true,
                          completion: nil)
        }
    }
    
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.updateViews()
        }
    }
    
    func loading(_ isLoading: Bool) {
        if isLoading {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.startAnimating()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
