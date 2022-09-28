//
//  APIClient+OKResponse.swift
//  Networking
//
//  Created by David Castro Cisneros on 28/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    static let OK_200 = 200
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
