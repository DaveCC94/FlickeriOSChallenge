//
//  PhotoFeedComposer.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit
import PhotoFeedFeature

final class PhotoFeedComposer {
    private init() { }
    
    static func photoFeedComposedWith(feedLoader: PhotoFeedLoader, imageLoader: ImageLoader) -> PhotoListViewController {
        let mainThreadPhotoLoader = MainQueueDispatchSanitizer(decoratee: feedLoader)
        let mainThreadImageLoader = MainQueueDispatchSanitizer(decoratee: imageLoader)
        
        let viewModel = PhotoFeedViewModel(photoLoader: mainThreadPhotoLoader)
        let refreshController = PhotoFeedRefreshViewController(viewModel: viewModel)
        let photoFeedVC = PhotoListViewController(refreshController: refreshController)
        
        photoFeedVC.onSearch = { [weak viewModel] in
            viewModel?.loadFeed(for: $0)
        }
        
        photoFeedVC.onBottomScroll = { [weak viewModel] in
            viewModel?.updatePage()
        }
        
        viewModel.onPhotoFeedLoad = adaptFreshLoad(sendTo: photoFeedVC, loader: mainThreadImageLoader)
        
        viewModel.onPhotoUpdated = { [weak photoFeedVC] in
            guard let photoFeedVC = photoFeedVC else { return }
            
            let newEntries = adaptPhotosToControllers(sendTo: photoFeedVC, loader: mainThreadImageLoader)($0)
            var currentPhotos = photoFeedVC.tableModel
            currentPhotos.append(contentsOf: newEntries)
            photoFeedVC.tableModel = currentPhotos
            photoFeedVC.update(cellControllers: currentPhotos)
        }
        
        return photoFeedVC
    }
    
    // MARK: - Helpers
    
    private static func adaptFreshLoad(sendTo controller: PhotoListViewController, loader: ImageLoader) -> ([Photo]) -> Void {
        return { [weak controller] photos in
            guard let controller = controller else { return }
            controller.tableModel = adaptPhotosToControllers(sendTo: controller, loader: loader)(photos)
            controller.display(cellControllers: controller.tableModel)
        }
    }
    
    private static func adaptPhotosToControllers(sendTo controller: PhotoListViewController, loader: ImageLoader) -> ([Photo]) -> [PhotoCellController] {
        return { [weak controller] photos in
            photos.map {
                let viewModel = PhotoViewModel<UIImage>(model: $0, imageLoader: loader, imageTransfomer: UIImage.init(data:))
                
                viewModel.onFullImageLoad = { [weak controller] in
                    controller?.dismissLoader()
                    controller?.navigationController?.pushViewController(PhotoDetailComposer.photoComposedWith(image: $0), animated: true)
                }
                
                viewModel.onFetchingImage = { [weak controller] _ in
                    controller?.showLoader()
                }
                
                return PhotoCellController(viewModel: viewModel)
            }
        }
    }
}
