//
//  APIClientSpy.swift
//  FlickrNetworkingTests
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Networking
import Foundation

final class APIClientSpy: APIClient {
    private struct Task: APIClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }

    var messages = [(url: URL, completion: (APIClient.Result) -> Void)]()
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }
    private(set) var cancelledURLs = [URL]()

    func get(from url: URL, completion: @escaping (APIClient.Result) -> Void) -> APIClientTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index],
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!

        messages[index].completion(.success((data, response)))
    }
}
