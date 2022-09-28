//
//  FlickrEndToEndTests.swift
//  FlickrEndToEndTests
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import XCTest
@testable import Networking

final class FlickrEndToEndTests: XCTestCase {
    func test_fetchesCats() {
        let expectation = expectation(description: "Consulting real flickr server")
        let query = "cats"
        let client = URLSessionAPIClient()
        let feedLoader = RemotePhotoFeedLoader(queryFactory: QueryToFlickrURLAdapter().adapt(query:page:), client: client)
        
        feedLoader.load(for: query, and: 1, completion: { result in
            expectation.fulfill()
            switch result {
            case let .success(feed):
                XCTAssertGreaterThan(feed.count, 0)
            case .failure:
                XCTFail("Unable to perform call")
            }
        })
        
        wait(for: [expectation], timeout: 10)
        
    }
}
