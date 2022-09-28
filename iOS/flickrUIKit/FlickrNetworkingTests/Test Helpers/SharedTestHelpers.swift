//
//  SharedTestHelpers.swift
//  FlickrNetworkingTests
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyNSError() -> NSError {
    return NSError(domain: "TEST", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

