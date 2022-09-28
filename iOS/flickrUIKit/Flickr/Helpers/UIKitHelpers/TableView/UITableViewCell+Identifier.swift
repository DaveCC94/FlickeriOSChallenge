//
//  UITableViewCell+Identifier.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    static var identifier: String { NSStringFromClass(self) }
}
