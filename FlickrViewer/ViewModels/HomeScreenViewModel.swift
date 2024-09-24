//
//  HomeScreenViewModel.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import Foundation

protocol HomeScreenViewModelDelegate {
    func refreshData()
    func loading(_ isLoading: Bool)
    func displayError(_ message: String)
}

class HomeScreenViewModel {
    
    var viewDelegate: HomeScreenViewModelDelegate
    private let networkService: NetworkServiceProtocol
    private(set) var images: [FlickrItem] = []
    
    init(viewDelegate: HomeScreenViewModelDelegate,
         networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.viewDelegate = viewDelegate
        searchImages(query: "")
    }
    
    func searchImages(query: String) {
        viewDelegate.loading(true)
        networkService
            .searchImages(query: query,
                          completion: { [weak self] result in
            self?.viewDelegate.loading(false)
            switch result {
            case .success(let feed):
                self?.images = feed.items
            case .failure(let error):
                self?.networkError(error)
            }
            self?.viewDelegate.refreshData()
        })
    }
    
    func networkError(_ error: NetworkError) {
        switch error {
        case .cancelled:
            print(error.message)
        default:
            viewDelegate.displayError(error.message)
        }
    }
}
