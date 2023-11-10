// Project: Amadeus
// Created By: Thadisha Thilakaratne

import Foundation

// MARK: Source Protocol

protocol Source {
    static func getSearchResult(title: String, offset: Int) async throws -> [Manga]
}

// MARK: Error Types

enum SourceError: Error {
    case badStatusCode
    case missingURL
}
