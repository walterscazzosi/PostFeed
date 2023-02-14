//
//  PostFeedResponse.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 14/02/23.
//

import Foundation

struct PostFeedResponse: Codable {
    var pagination: Pagination?
    var statusCode: Int?
    var message: String?
    var result: [Post]?
}

struct Pagination: Codable {
    var hasNext: Bool?
}

struct Post: Codable {
    var id: String?
    var type: String?
    var date: String?
    var reactions: Reactions?
    var user: User?
    var mediaItems: [MediaItem]?
}

struct Reactions: Codable {
    var likesCount: Int?
}

struct User: Codable {
    var name: String?
}

struct MediaItem: Codable {
    var type: String?
    var mediaEndpoint: String?
    var thumbnailPath: String?
}
