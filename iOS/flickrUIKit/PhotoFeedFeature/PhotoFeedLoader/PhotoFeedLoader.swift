//
//  PhotoFeedLoader.swift
//  PhotoFeedFeature
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public protocol PhotoFeedLoader {
    typealias Result = Swift.Result<[Photo], Error>

    func load(for text: String, and page: Int, completion: @escaping (Result) -> Void) 
}
