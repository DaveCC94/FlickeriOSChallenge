//
//  PhotoDetailViewController.swift
//  Flickr
//
//  Created by David Castro Cisneros on 30/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

final class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    private var scroll: UIScrollView = {
        let sv = UIScrollView()
        sv.minimumZoomScale = 0.5
        sv.maximumZoomScale = 6.0
        sv.zoomScale = 1.01
        sv.showsVerticalScrollIndicator = true
        sv.showsHorizontalScrollIndicator = true
        sv.flashScrollIndicators()
        sv.bouncesZoom = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setUp(with image: UIImage) {
        photoView.image = image
        photoView.alpha = 0.5
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.photoView.alpha = 1.0
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scroll)
        scroll.addSubview(photoView)
        scroll.delegate = self
        scroll.contentSize = .init(width: view.frame.width, height: view.frame.height)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoView
    }
}
