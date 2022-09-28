//
//  UITableView+DequeueCell.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        if let cell =  dequeueReusableCell(withIdentifier: T.identifier) as? T {
            return cell
        } else {
            assertionFailure("Unable to dequeue cell of type: \(T.self) for identifier: \(T.identifier)")
            return T()
        }
    }
}
