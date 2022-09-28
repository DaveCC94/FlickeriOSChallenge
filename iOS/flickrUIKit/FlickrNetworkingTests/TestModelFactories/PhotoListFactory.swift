//
//  PhotoListFactory.swift
//  FlickrNetworkingTests
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation
@testable import Networking

final class PhotoListFactory {
    typealias TestModel = (model: RemotePhotoList, json: [String: Any])
    
    private init() { }

    static func make(photos: [PhotoFactory.TestModel],
                     page: Int,
                     pages: Int) -> PhotoListFactory.TestModel {
        let photoList = RemotePhotoList(photo: photos.map { $0.model }, page: page, pages: pages)
        
        let json: [String: Any] = [
            "photos": [
                "page": page,
                "pages": pages,
                "photo": photos.map { $0.json }
            ]
        ]

        return (model: photoList, json: json)
    }
}
