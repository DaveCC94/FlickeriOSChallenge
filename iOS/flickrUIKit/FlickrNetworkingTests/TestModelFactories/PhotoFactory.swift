//
//  PhotoFactory.swift
//  FlickrNetworkingTests
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation
@testable import Networking

final class PhotoFactory {
    typealias TestModel = (model: RemotePhoto, json: [String: Encodable])
    
    private init() { }

    static func make(id: String,
                     farm: Int,
                     server: String,
                     secret: String) -> PhotoFactory.TestModel {
        let photo = RemotePhoto(id: id, farm: farm, server: server, secret: secret)
        
        let json: [String: Encodable] = [
            "id": photo.id,
            "farm": photo.farm,
            "server": photo.server,
            "secret": photo.secret
        ]

        return (model: photo, json: json)
    }
}
