//
//  PostFeedListViewModel.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 13/02/23.
//

import Foundation

final class PostFeedListViewModel {
    // MARK: - Services
    private let postFeedService: PostFeedService
    
    // MARK: - Properties
    var posts = [Post]()
    var hasNextPage = false
    
    // MARK: - Initializers
    init(postFeedService: PostFeedService) {
        self.postFeedService = postFeedService
    }

    // MARK: - Methods
    func fetchPostFeed(completionHandler: @escaping () -> Void) {
        postFeedService.fetchPostFeed(skip: posts.count) { [weak self] postFeedResponse in
            self?.hasNextPage = postFeedResponse.pagination?.hasNext == true
            if let postsToShow = postFeedResponse.result?.filter({ $0.type == "image" }) {
                self?.posts.append(contentsOf: postsToShow)
                completionHandler()
            }
        }
    }
}
