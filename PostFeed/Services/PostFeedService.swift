//
//  PostFeedListService.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 13/02/23.
//

import Foundation

final class PostFeedService {
    // MARK: - Properties
    private let endpoint = "https://services-dev.tatatu.com/postsvc/v1.0/timelines/home"
    
    // MARK: - Methods
    func fetchPostFeed(skip: Int, completionHandler: @escaping (PostFeedResponse) -> Void) {
        var urlComps = URLComponents(string: endpoint)
        
        let queryItems = [URLQueryItem(name: "skip", value: String(skip)), URLQueryItem(name: "limit", value: "20")]
        urlComps?.queryItems = queryItems
        
        guard let url = urlComps?.url,
              let accessTokenPath = Bundle.main.path(forResource: "AccessToken", ofType: "txt"),
              let accessToken = try? String(contentsOfFile: accessTokenPath, encoding: .utf8) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error == nil,
               let data = data {
                do {
                    let postFeedResponse = try JSONDecoder().decode(PostFeedResponse.self, from: data)
                    completionHandler(postFeedResponse)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
