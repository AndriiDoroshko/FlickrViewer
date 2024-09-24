//
//  MockNetworkService.swift
//  FlickrViewerTests
//
//  Created by Andrey Doroshko on 9/24/24.
//

import Foundation
@testable import FlickrViewer
import UIKit

class MockNetworkService: NetworkServiceProtocol {
    
    var invokedSearchImages = false
    var invokedSearchImagesCount = 0
    var stubbedSearchImagesResponse: Result<FlickrViewer.FlickrFeed, FlickrViewer.NetworkError>?
    func searchImages(query: String, completion: @escaping (Result<FlickrViewer.FlickrFeed, FlickrViewer.NetworkError>) -> ()) {
        invokedSearchImages = true
        invokedSearchImagesCount += 1
        guard let response = stubbedSearchImagesResponse else { return }
        completion(response)
    }
    
    var invokedDownloadImage = false
    var invokedDownloadImageCount = 0
    var stubbedDownloadImageResponse: Result<UIImage, FlickrViewer.NetworkError>?
    func downloadImage(from urlString: String, completion: @escaping (Result<UIImage, FlickrViewer.NetworkError>) -> ()) {
        invokedDownloadImage = true
        invokedDownloadImageCount += 1
        guard let response = stubbedDownloadImageResponse else { return }
        completion(response)
    }
}
