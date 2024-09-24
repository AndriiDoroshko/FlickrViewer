//
//  Protocols.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func searchImages(query: String,
                      completion: @escaping (Result<FlickrFeed,NetworkError>) -> ())
    func downloadImage(from urlString: String,
                       completion: @escaping (Result<UIImage, NetworkError>) -> ()) 
}
