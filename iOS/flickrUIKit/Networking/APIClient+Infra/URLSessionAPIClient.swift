//
//  URLSessionAPIClient.swift
//  Networking
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public class URLSessionAPIClient: APIClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error { }

    public func get(from url: URL, completion: @escaping (APIClient.Result) -> Void) -> APIClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }
        task.resume()
        
        return URLSessionTaskWrapper(wrapped: task)
    }

    private struct URLSessionTaskWrapper: APIClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }
}
