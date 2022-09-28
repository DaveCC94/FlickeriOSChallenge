//
//  PhotoDetailComposer.swift
//  Flickr
//
//  Created by David Castro Cisneros on 30/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

final class PhotoDetailComposer {
    private init() { }
    
    static func photoComposedWith(image: UIImage) -> PhotoDetailViewController {
        let controller = PhotoDetailViewController()
        
        controller.setUp(with: image)
        
        return controller
    }
}
