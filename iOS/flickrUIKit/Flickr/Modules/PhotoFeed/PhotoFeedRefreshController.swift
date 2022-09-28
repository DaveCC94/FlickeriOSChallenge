//
//  PhotoFeedRefreshController.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit
import PhotoFeedFeature

final class PhotoFeedRefreshViewController: NSObject {
    private(set) lazy var view = binded(UIRefreshControl())
    private let viewModel: PhotoFeedViewModel

    init(viewModel: PhotoFeedViewModel) {
        self.viewModel = viewModel
    }

    @objc func refresh() {
        viewModel.loadFeed(for: "")
    }

    // - MARK: MVVM Binding

    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            if isLoading {
                view?.beginRefreshing()
            } else {
                view?.endRefreshing()
            }
        }
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return view
    }
}
