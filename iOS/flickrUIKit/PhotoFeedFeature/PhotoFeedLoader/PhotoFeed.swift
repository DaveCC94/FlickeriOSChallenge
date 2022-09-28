//
//  PhotoFeed.swift
//  PhotoFeedFeature
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public struct PhotoFeed: Equatable {
    public let photos: [Photo]
    public let page: Int
    public let pages: Int
    
    public init(photos: [Photo], page: Int, pages: Int) {
        self.photos = photos
        self.page = page
        self.pages = pages
    }
}
