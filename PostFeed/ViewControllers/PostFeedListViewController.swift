//
//  PostFeedListViewController.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 13/02/23.
//

import UIKit

class PostFeedListViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: PostFeedListViewModel? = nil
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostFeedListTableViewCell.self, forCellReuseIdentifier: PostFeedListTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraint()
        setupAppearance()
        fetchPostFeed()
    }
    
    // MARK: - Setup
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraint() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: margins.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Post Feed List"
    }
    
    // MARK: - Configure
    func configure(viewModel: PostFeedListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Methods
    private func fetchPostFeed() {
        viewModel?.fetchPostFeed {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PostFeedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostFeedListTableViewCell.reuseIdentifier) as? PostFeedListTableViewCell,
              let posts = viewModel?.posts
        else {
            return UITableViewCell()
        }
        cell.configure(viewModel: PostFeedListCellViewModel(post: posts[indexPath.row], isSeparatorHidden: indexPath.row == posts.count - 1))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostFeedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailsViewController = PostDetailsViewController()
        if let mediaItems = viewModel?.posts[indexPath.row].mediaItems {
            postDetailsViewController.configure(viewModel: PostDetailsViewModel(mediaItems: mediaItems))
        }
        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let posts = viewModel?.posts, indexPath.row == posts.count - 1 && viewModel?.hasNextPage == true {
            fetchPostFeed()
        }
    }
}
