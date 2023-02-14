//
//  PostDetailsViewController.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 14/02/23.
//

import UIKit

class PostDetailsViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: PostDetailsViewModel? = nil
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(PostDetailsCollectionViewCell.self, forCellWithReuseIdentifier: PostDetailsCollectionViewCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraint()
        setupAppearance()
    }
    
    // MARK: - Setup
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: margins.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = "Post Detail"
    }
    
    // MARK: - Configure
    func configure(viewModel: PostDetailsViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource
extension PostDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.mediaItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostDetailsCollectionViewCell.reuseIdentifier, for: indexPath) as? PostDetailsCollectionViewCell,
              let mediaItem = viewModel?.mediaItems[indexPath.row],
              let thumbnailPath = mediaItem.thumbnailPath
        else {
            return UICollectionViewCell()
        }
        cell.configure(viewModel: PostDetailsCellViewModel(thumbnailPath: thumbnailPath))
        return cell
    }
}

