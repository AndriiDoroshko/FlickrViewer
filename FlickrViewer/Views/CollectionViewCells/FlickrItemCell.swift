//
//  FlickrItemCell.swift
//  FlickrViewer
//
//  Created by Andrey Doroshko on 9/23/24.
//

import UIKit

class FlickrItemCell: UICollectionViewCell {
    
    static let identifier = "FlickrItemCell"
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private(set) var cellModel: FlickrItemCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        confugureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confugureLayout() {
        contentView.layer.cornerRadius = 16.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16.0
        imageView.addRefreshControl(activityIndicator)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with model: FlickrItemCellModel) {
        self.cellModel = model
        titleLabel.text = model.flickrItem.title
        imageView.image = nil
        
        activityIndicator.startAnimating()
        model.loadImage { [weak self] loadedImage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.imageView.image = loadedImage
            }
        }
    }
}
