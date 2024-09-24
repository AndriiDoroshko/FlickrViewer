//
//  ViewController.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    private(set) lazy var viewModel
    = HomeScreenViewModel(viewDelegate: self)
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    private let pullToRefreshView = PullToRefreshView(frame: .zero)
    private let searchBar = UISearchBar()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenSize: CGRect = UIScreen.main.bounds
        let width = (screenSize.width / 2) - 16
        layout.itemSize = CGSize(width: width, height: 300)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        configureLayout()
    }
    
    func configureLayout() {
        view.backgroundColor = .systemBackground
        title = "Explore Flickr"

        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.placeholder = "Search Flickr"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self,
                            action: #selector(refreshStream),
                            for: .valueChanged)
        collectionView.refreshControl = refresher
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0.0,
                                                   left: 8.0,
                                                   bottom: 0.0,
                                                   right: 8.0)
        collectionView.register(FlickrItemCell.self,
                                forCellWithReuseIdentifier: FlickrItemCell.identifier)
       
        pullToRefreshView.isHidden = !viewModel.images.isEmpty
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(pullToRefreshView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pullToRefreshView.translatesAutoresizingMaskIntoConstraints = false

        // Set constraints
        NSLayoutConstraint.activate([
            pullToRefreshView.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor),
            pullToRefreshView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pullToRefreshView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func refreshStream() {
        searchBarSearchButtonClicked(searchBar)
    }
}

extension ViewController: HomeScreenViewModelDelegate {
    func displayError(_ message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
           
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)
           
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.present(alertController,
                                                animated: true,
                                                completion: nil)
        }
    }
    
    func loading(_ isLoading: Bool) {
        if isLoading {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.pullToRefreshView.isHidden = true
                self.collectionView.refreshControl?.beginRefreshing(in: self.collectionView)
            }
            return
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.refreshControl?.endRefreshing()
                self.pullToRefreshView.isHidden = !self.viewModel.images.isEmpty
            }
        }
    }
    
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FlickrItemCell
        = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: FlickrItemCell.identifier,
                for: indexPath)
        as! FlickrItemCell
        
        let viewModel
        = FlickrItemCellModel(flickrItem: viewModel.images[indexPath.item])
        cell.configure(with: viewModel)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.viewModel
        = DetailsViewModel(flickrItem: viewModel.images[indexPath.item],
                           viewDelegate: detailsViewController)
         let navigationControllerWithDetails = UINavigationController(rootViewController: detailsViewController)
        navigationController?.present(navigationControllerWithDetails, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
           if let searchText = searchBar.text {
               viewModel.searchImages(query: searchText)
           }
       }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if let searchText = searchBar.text {
            viewModel.searchImages(query: searchText)
        }
    }
}
