// Project: Amadeus
// Created By: Thadisha Thilakaratne

import Foundation
import SwiftUI

class Manga: Identifiable, Codable {
    // Identifier
    var source: String
    var id: String
    
    // Details
    var title: String?
    var description: String?
    var status: String?
    var author: String?
    var tags: [String]?
    var coverURL: URL?
    var cover: Data?
    
    // Constructor
    init(source: String, id: String) {
        self.source = source
        self.id = id
    }
}
