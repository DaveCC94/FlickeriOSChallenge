//
//  RemoteImageLoader.swift
//  Networking
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation
import PhotoFeedFeature

public final class RemoteImageLoader: ImageLoader {
    private let client: APIClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(client: APIClient) {
        self.client = client
    }

    public func loadImageData(from url: URL, completion: @escaping (ImageLoader.Result) -> Void) -> ImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                            .mapError { _ in Error.connectivity }
                            .flatMap { (data, response) in
                let isValidResponse = response.isOK && !data.isEmpty
                return isValidResponse ? .success(data) : .failure(Error.invalidData)
            })
        }
        return task
    }

    private final class HTTPClientTaskWrapper: ImageDataLoaderTask {
        private var completion: ((ImageLoader.Result) -> Void)?

        var wrapped: APIClientTask?

        init(_ completion: @escaping (ImageLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: ImageLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }
}
