// Project: Amadeus
// Created By: Thadisha Thilakaratne

import Foundation
import SwiftyJSON

class Mangadex: Source {
    private static let scheme = "https"
    private static let host = "api.mangadex.org"
    private static let source = "Mangadex"
}

extension Mangadex {
    static func getSearchResult(title: String, offset: Int) async throws -> [Manga] {
        // Build URL
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = "/manga"
        components.queryItems = [
            URLQueryItem(name: "limit", value: "50"),
            URLQueryItem(name: "offset", value: String(50 * offset)),
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "includes[]", value: "author"),
            URLQueryItem(name: "includes[]", value: "cover_art"),
            URLQueryItem(name: title.isEmpty ? "order[followedCount]" : "order[relevance]", value: "desc")
        ]

        // Send request
        guard let url = components.url else {
            throw SourceError.missingURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Handle response
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw SourceError.badStatusCode
        }
        let result = JSON(data)["data"]
        
        // Extract data
        var list: [Manga] = []
        try await withThrowingTaskGroup(of: Manga.self) { group in
            for sub in result.arrayValue {
                group.addTask {
                    let manga = Manga(source: self.source, id: sub["id"].stringValue)
                    
                    // Title
                    let title = sub["attributes"]["title"]["en"].string ??
                                sub["attributes"]["title"]["ja_ro"].string ??
                                sub["attributes"]["title"].dictionary?.values.first?.string
                    manga.title = title
                    
                    // Description
                    let description = sub["attributes"]["description"]["en"].string ??
                                      sub["attributes"]["description"]["ja_ro"].string ??
                                      sub["attributes"]["description"].dictionary?.values.first?.string
                    manga.description = description
                    
                    // Cover Art
                    for relationship in sub["relationships"].arrayValue {
                        if relationship["type"] == "cover_art" {
                            let endpoint = "https://mangadex.org/covers/\(sub["id"].string!)/\(relationship["attributes"]["fileName"].string ?? "")"
                            let size = ".512.jpg"
                            manga.coverURL = URL(string: endpoint + size)
                        }
                        else if relationship["type"] == "author" {
                            manga.author = relationship["attributes"]["name"].string
                        }
                    }
                    
                    // Tags
                    var tags: [String] = []
                    for tag in sub["attributes"]["tags"].arrayValue {
                        if let name = tag["attributes"]["name"]["en"].string ?? tag["attributes"]["name"]["ja_ro"].string {
                            tags.append(name)
                        }
                    }
                    manga.tags = tags
                    
                    // Status
                    let status = (sub["attributes"]["status"].string ?? "").capitalized
                    manga.status = status
                    
                    // Return manga
                    return manga
                }
            }
            
            // Add parsed manga to list
            for try await manga in group {
                list.append(manga)
            }
        }
        
        // Return list
        return list
    }
}
