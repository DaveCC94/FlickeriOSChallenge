//
//  ImageLoader.swift
//  PhotoFeedFeature
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public protocol ImageLoader {
    typealias Result = (Swift.Result<Data, Error>)

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask
}

public protocol ImageDataLoaderTask {
    func cancel()
}

