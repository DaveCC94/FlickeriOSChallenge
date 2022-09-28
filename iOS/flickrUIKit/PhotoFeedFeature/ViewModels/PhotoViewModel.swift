//
//  PhotoViewModel.swift
//  PhotoFeedFeature
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public final class PhotoViewModel<Image> {
    public typealias Observer<T> = (T) -> Void

    private let model: Photo
    private let imageLoader: ImageLoader
    private var task: ImageDataLoaderTask?
    private let imageTransformer: (Data) -> Image?

    public var onImageLoad: Observer<Image>?
    public var onFullImageLoad: Observer<Image>?
    public var onImageLoadingStateChange: Observer<Bool>?
    public var onShouldRetryImageLoadingStateChange: Observer<Bool>?
    public var onFetchingImage: Observer<Void>?

    public init(model: Photo, imageLoader: ImageLoader, imageTransfomer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransfomer
    }

    public func loadImageData() {
        onFetchingImage?(())
        task = imageLoader.loadImageData(from: model.imageURL, completion: { [weak self] result in
            self?.handleFullImage(result)
        })
    }
    
    public func loadThumbnailData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadingStateChange?(false)
        
        task = imageLoader.loadImageData(from: model.thumbnailURL, completion: { [weak self] result in
            self?.handle(result)
        })
    }


    public func cancelLoad() {
        task?.cancel()
    }

    private func handle(_ result: ImageLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
            onShouldRetryImageLoadingStateChange?(false)
        } else {
            onShouldRetryImageLoadingStateChange?(true)
        }

        self.onImageLoadingStateChange?(false)
    }
    
    private func handleFullImage(_ result: ImageLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onFullImageLoad?(image)
        }
        
        self.onImageLoadingStateChange?(false)
    }
}

