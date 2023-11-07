//
//  Item.swift
//  Amadeus
//
//  Created by Thadisha Thilakaratne on 7/11/2023.
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
