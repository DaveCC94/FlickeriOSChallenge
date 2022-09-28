//
//  PhotoFeedMainThreadSanitizer.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import PhotoFeedFeature

extension MainQueueDispatchSanitizer: PhotoFeedLoader where T == PhotoFeedLoader {
    func load(for text: String, and page: Int, completion: @escaping (PhotoFeedLoader.Result) -> Void) {
        decoratee.load(for: text, and: page) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
