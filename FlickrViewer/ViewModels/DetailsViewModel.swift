//
//  DetailsViewModel.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import Foundation
import UIKit

protocol DetailsViewModelDelegate: AnyObject {
    func refreshData()
    func loading(_ isLoading: Bool)
    func displayError(_ message: String)
}

class DetailsViewModel {
    
    weak var viewDelegate: DetailsViewModelDelegate?
    private let networkService: NetworkServiceProtocol
    
    private(set) var flickrItem: FlickrItem
    private(set) var image: UIImage? = nil
    
    init(flickrItem: FlickrItem,
         viewDelegate: DetailsViewModelDelegate,
         networkService: NetworkServiceProtocol = NetworkService()) {
        self.flickrItem = flickrItem
        self.viewDelegate = viewDelegate
        self.networkService = networkService
        downloadImage(query: flickrItem.media.m)
    }
    
    func downloadImage(query: String) {
        viewDelegate?.loading(true)
        networkService.downloadImage(from: query) { [weak self] result in
            self?.viewDelegate?.loading(false)
            switch result {
            case .success(let image):
                self?.image = image
                self?.viewDelegate?.refreshData()
            case .failure(let error):
                self?.networkError(error)
            }
        }
    }
    
    func networkError(_ error: NetworkError) {
        switch error {
        case .cancelled:
            print("DetailsViewModel Error: \(error.message)")
        default:
            viewDelegate?.displayError(error.message)
        }
    }
}
