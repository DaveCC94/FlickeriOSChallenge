//
//  RemotePhotoFeedLoader.swift
//  Networking
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation
import PhotoFeedFeature

public final class RemotePhotoFeedLoader: PhotoFeedLoader {
    public typealias Result = PhotoFeedLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidSearch
        case invalidData
    }
    
    private let client: APIClient
    private let queryFactory: (String, String) -> URL?
    
    public init(queryFactory: @escaping (String, String) -> URL?, client: APIClient) {
        self.client = client
        self.queryFactory = queryFactory
    }
    
    public func load(for text: String, and page: Int, completion: @escaping (Result) -> Void) {
        guard let url = queryFactory(text, "\(page)") else {
            completion(.failure(Error.invalidSearch))
            return
        }
        
        client.get(from: url, completion: { result in
            switch result {
            case let .success((data, response)):
                completion(RemotePhotoFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        })
    }
    
    // MARK: - Private Methods
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let remotePhotos = try RemotePhotosMapper.map(data, from: response)
            return .success(remotePhotos.toModel().photos)
        } catch {
            return .failure(RemotePhotoFeedLoader.Error.invalidData)
        }
    }
}

private final class RemotePhotosMapper {
    private struct Root: Decodable {
        let photos: RemotePhotoList
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> RemotePhotoList {
        let jsonDecoder = JSONDecoder()
        
        guard response.statusCode == HTTPURLResponse.OK_200,
              let root = try? jsonDecoder.decode(Root.self, from: data) else {
            throw RemotePhotoFeedLoader.Error.invalidData
        }
        
        return root.photos
    }
}

private extension RemotePhotoList {
    func toModel() -> PhotoFeed {
        let photos: [Photo] = self.photo.compactMap {
            if let thumbnailURL = $0.thumbnailUrl, let photoURL = $0.largeUrl {
                return Photo(thumbnailURL: thumbnailURL, imageURL: photoURL)
            }
            
            return nil
        }
        
        return .init(photos: photos, page: page, pages: pages)
    }
}

