//
//  PullToRefreshView.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/24/24.
//

import UIKit

class PullToRefreshView: UIView {
    
    private let arrowImageView = UIImageView()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        arrowImageView.image = UIImage(systemName: "arrow.down")
        
        textLabel.text = "Pull to Refresh"
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 14)

        addSubview(arrowImageView)
        addSubview(textLabel)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        // Layout Constraints
        NSLayoutConstraint.activate([
            arrowImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            arrowImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: arrowImageView.bottomAnchor, constant: 8),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}

