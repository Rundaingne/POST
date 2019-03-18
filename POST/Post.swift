//
//  File.swift
//  POST
//
//  Created by Brooke Kumpunen on 3/18/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    let text: String
    let timestamp: TimeInterval = Date().timeIntervalSince1970
    let username: String
}
