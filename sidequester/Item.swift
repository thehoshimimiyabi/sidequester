//
//  Item.swift
//  TARDIS
//
//  Created by Rayson Ng on 29/6/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
