//
//  Photo.swift
//  PhotoFeedFeature
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public struct Photo: Equatable {
    public let thumbnailURL: URL
    public let imageURL: URL
    
    public init(thumbnailURL: URL, imageURL: URL) {
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
    }
}
