//
//  PostFeedListTableViewCell.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 14/02/23.
//

import UIKit

final class PostFeedListTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = String(describing: PostFeedListTableViewCell.self)
    
    // MARK: - Views
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, postImageView, likesLabel, dateLabel, separator])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var authorLabel = UILabel()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var likesLabel = UILabel()
    
    private lazy var dateLabel = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraint()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func addSubviews() {
        contentView.addSubview(containerStackView)
    }
    
    private func setupConstraint() {
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 250),
            separator.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    private func setupAppearance() {
        selectionStyle = .none
    }
    
    // MARK: - Configure
    func configure(viewModel: PostFeedListCellViewModel) {
        separator.isHidden = viewModel.isSeparatorHidden
        let post = viewModel.post
        
        authorLabel.text = "Author: \(post.user?.name ?? "")"
        if let mediaEndpoint = post.mediaItems?.first?.mediaEndpoint,
           let url = URL(string: mediaEndpoint) {
            Helper.downloadImage(from: url) { data in
                DispatchQueue.main.async { [weak self] in
                    self?.postImageView.image = UIImage(data: data)
                }
            }
        }
        likesLabel.text = "Likes count: \(post.reactions?.likesCount ?? 0)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let dateString = post.date, let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateLabel.text = "Date created: \(dateFormatter.string(from: date))"
        }
    }
    
    // MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        authorLabel.text = nil
        postImageView.image = nil
        likesLabel.text = nil
        dateLabel.text = nil
    }
}
