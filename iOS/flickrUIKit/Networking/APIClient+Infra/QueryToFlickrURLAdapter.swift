//
//  QueryToFlickrURLAdapter.swift
//  Networking
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public final class QueryToFlickrURLAdapter {
    private let key: String
    public init(key: String = "675894853ae8ec6c242fa4c077bcf4a0") {
        self.key = key
    }
    
    public func adapt(query: String, page: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "text", value: query),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "page", value: page)
        ]

        return components.url
    }
}
