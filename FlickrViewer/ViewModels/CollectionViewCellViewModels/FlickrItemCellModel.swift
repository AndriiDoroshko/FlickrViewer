//
//  FlickrItemCellModel.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import Foundation
import UIKit

class FlickrItemCellModel {
    let flickrItem: FlickrItem
    private(set) var image: UIImage?
    private let networkService: NetworkServiceProtocol = NetworkService()

    init(flickrItem: FlickrItem) {
        self.flickrItem = flickrItem
    }

    func loadImage(completion: @escaping (UIImage?) -> Void) {
        networkService.downloadImage(from: flickrItem.media.m) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
                completion(image)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
}
