//
//  PostDetailsCollectionViewCell.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 14/02/23.
//

import UIKit

final class PostDetailsCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = String(describing: PostDetailsCollectionViewCell.self)
    
    // MARK: - Views
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraint()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func addSubviews() {
        contentView.addSubview(postImageView)
    }
    
    private func setupConstraint() {
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupAppearance() {}
    
    // MARK: - Configure
    func configure(viewModel: PostDetailsCellViewModel) {
        if let url = URL(string: viewModel.thumbnailPath) {
            Helper.downloadImage(from: url) { data in
                DispatchQueue.main.async { [weak self] in
                    self?.postImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    // MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
}
