//
//  ViewExtensions.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import UIKit

extension UIRefreshControl {
    func beginRefreshing(in collection: UICollectionView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: -8, y: -frame.size.height)
        collection.setContentOffset(offsetPoint, animated: true)
    }
}

extension UIImageView {
    func addRefreshControl(_ activityIndicator: UIActivityIndicatorView) {
        let parentView = UIView()
        
        parentView.addSubview(activityIndicator)
        self.addSubview(parentView)
        self.bringSubviewToFront(parentView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        parentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: self.topAnchor),
            parentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
    }
}
