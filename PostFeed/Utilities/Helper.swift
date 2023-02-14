//
//  Helper.swift
//  PostFeed
//
//  Created by Walter Scazzosi on 14/02/23.
//

import Foundation

struct Helper {
    static func downloadImage(from url: URL, completionHandler: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error == nil,
               let data = data {
                completionHandler(data)
            }
        }.resume()
    }
}
