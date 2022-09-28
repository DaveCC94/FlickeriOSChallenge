//
//  NotificationCenter+SearchController.swift.swift
//  Flickr
//
//  Created by David Castro Cisneros on 30/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit
import Combine

extension NotificationCenter {
    static func publisherFor(searchController: UISearchController) -> AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .map {
                ($0.object as? UISearchTextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}
