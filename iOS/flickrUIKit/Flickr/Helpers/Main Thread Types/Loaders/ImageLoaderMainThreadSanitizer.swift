//
//  ImageLoaderMainThreadSanitizer.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation
import PhotoFeedFeature

extension MainQueueDispatchSanitizer: ImageLoader where T == ImageLoader {
    func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageDataLoaderTask {

        decoratee.loadImageData(from: url, completion: { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        })
    }
}
