//
//  PhotoCellController.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation
import PhotoFeedFeature
import UIKit

final class PhotoCellController {
    private let id: UUID = .init()
    private let viewModel: PhotoViewModel<UIImage>

    init(viewModel: PhotoViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(tableView: UITableView) -> UITableViewCell {
        let cell: PhotoCell = binded(tableView.dequeueReusableCell())
        viewModel.loadThumbnailData()
        return cell
    }
    
    func preload() {
        viewModel.loadThumbnailData()
    }
    
    func loadFullSize() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        viewModel.cancelLoad()
    }
    
    // MARK: - MVVM Binding

    private func binded(_ cell: PhotoCell) -> PhotoCell {
        viewModel.onImageLoad = { [weak cell] image in
            cell?.setImage(image)
            cell?.photoImageView.alpha = 0.5
            
            UIView.animate(withDuration: 0.3, animations: { [weak cell] in
                cell?.photoImageView.alpha = 1.0
            })
        }

        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            if isLoading {
                cell?.photoImageView.startShimmering()
            } else {
                cell?.photoImageView.stopShimmering()
            }
        }
        
        return cell
    }
}

// MARK: - Diffable Data Source Requeriments

extension PhotoCellController: Equatable {
    static func == (lhs: PhotoCellController, rhs: PhotoCellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension PhotoCellController: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
