//
//  PhotoFeedViewModel.swift
//  PhotoFeedFeature
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

public final class PhotoFeedViewModel {
    public typealias Observer<T> = (T) -> Void

    public var onLoadingStateChange: Observer<Bool>?
    public var onPhotoFeedLoad: Observer<[Photo]>?
    public var onPhotoUpdated: Observer<[Photo]>?
    public var onFeedFail: Observer<Error>?
    private var currentPage = 1
    private var currentSearch = ""

    private let photoLoader: PhotoFeedLoader

    public init(photoLoader: PhotoFeedLoader) {
        self.photoLoader = photoLoader
    }

    public func loadFeed(for search: String) {
        currentPage = 1
        currentSearch = search
        
        guard !search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onPhotoFeedLoad?([])
            onLoadingStateChange?(false)
            return
        }
        
        onLoadingStateChange?(true)
        
        photoLoader.load(for: search, and: currentPage, completion: { [weak self] result in
            switch result {
            case let .success(photos):
                self?.onPhotoFeedLoad?(photos)
            case let .failure(error):
                self?.onFeedFail?(error)
            }
            self?.onLoadingStateChange?(false)
        })
    }
    
    public func updatePage() {
        currentPage += 1
        onLoadingStateChange?(true)
        
        photoLoader.load(for: currentSearch, and: currentPage, completion: { [weak self] result in
            switch result {
            case let .success(photos):
                self?.onPhotoUpdated?(photos)
            case let .failure(error):
                self?.onFeedFail?(error)
            }
            self?.onLoadingStateChange?(false)
        })
    }
}
