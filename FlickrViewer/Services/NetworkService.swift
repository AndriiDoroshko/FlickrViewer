//
//  NetworkService.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL(String)
    case nerworkError(String)
    case noDataRecived(String)
    case decodingJSONError(String)
    case cancelled
    
    var message: String {
        switch self {
        case .invalidURL(let message):
            return message
        case .nerworkError(let message):
            return message
        case .noDataRecived(let message):
            return message
        case .decodingJSONError(let message):
            return message
        case .cancelled:
            return "Network request was canceled"
        }
    }
}

enum NetworkURLs {
    static let feedsUrlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
}

class NetworkService: NetworkServiceProtocol {
    var searchDataTask: URLSessionDataTask?
    var downloadCellDataTask: URLSessionDataTask?
    
    deinit {
        searchDataTask?.cancel()
        downloadCellDataTask?.cancel()
    }
    
    // Inside your ViewController class
    func searchImages(query: String,
                      completion: @escaping (Result<FlickrFeed,NetworkError>) -> ()) {
        let formattedQuery
        = query.replacingOccurrences(of: " ", with: ",")
        
        let urlString
        = NetworkURLs.feedsUrlString + formattedQuery
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL("Invalid URL.")))
            return
        }
        
        searchDataTask?.cancel()
        searchDataTask
        = URLSession
            .shared
            .dataTask(with: url) { (data, response, error) in
                // Handle errors
                if let error = error {
                    switch error.localizedDescription {
                    case "cancelled":
                        completion(.failure(NetworkError.cancelled))
                    default:
                        completion(.failure(NetworkError.nerworkError(error.localizedDescription)))
                    }
                    return
                }
                
                // Check for valid response and data
                guard let data = data else {
                    completion(.failure(NetworkError.noDataRecived("No data received.")))
                    return
                }
                
                // Decode the JSON response
                do {
                    let flickrFeed = try JSONDecoder().decode(FlickrFeed.self, from: data)
                    completion(.success(flickrFeed))
                } catch {
                    completion(.failure(NetworkError.decodingJSONError(error.localizedDescription)))
                }
            }
        
        // Start the network task
        searchDataTask?.resume()
    }
    
    func downloadImage(from urlString: String,
                       completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL("")))
            return
        }
        
        downloadCellDataTask?.cancel()
        
        downloadCellDataTask
        = URLSession
            .shared
            .dataTask(with: url) { data, response, error in
            if let error = error {
                switch error.localizedDescription {
                case "cancelled":
                    completion(.failure(NetworkError.cancelled))
                default:
                    completion(.failure(NetworkError.nerworkError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noDataRecived("Data is missing in response")))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(NetworkError.decodingJSONError("Data recived is not an image")))
                return
            }
            completion(.success(image))
        }
        downloadCellDataTask?.resume()
    }
}
