// Project: Amadeus
// Created By: Thadisha Thilakaratne

import SwiftUI

struct BrowseView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

class BrowseViewModel: ObservableObject {
    private var offset = 0
    private var text = ""
    private var list: [Manga] = []
    
    // Send request
    private func send() -> Void {
        DispatchQueue.main.async {
            Task {
                do {
                    try await Mangadex.getSearchResult(title: self.text, offset: self.offset)
                } catch {
                    print("Error found while fetching data")
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Submit search
    func submit(text: String) {
        self.text = text
        self.offset = 0
        self.list.removeAll()
        self.send()
    }
    
    // Get more results
    private func next() -> Void {
        self.offset += 1
        self.send()
    }
}

#Preview {
    BrowseView()
}
