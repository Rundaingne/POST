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
    let timestamp: TimeInterval
    let username: String
    var queryTimestamp: TimeInterval {
        get {
            return self.timestamp - 0.00001
        }
    }
    
    init(text: String, username: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.text = text
        self.username = username
        self.timestamp = timestamp
    }
}
