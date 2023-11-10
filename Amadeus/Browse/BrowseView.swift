// Project: Amadeus
// Created By: Thadisha Thilakaratne

import SwiftUI

// MARK: Browse View

struct BrowseView: View {
    // State
    @StateObject private var vm = BrowseViewModel()
    
    // Grid Dimensions
    private let columns = Array(repeating: GridItem(. flexible(), spacing: 0), count: 2)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    Spacer(minLength: 2)
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(vm.list) { manga in
                            NavigationLink {
                                LibraryView()
                            } label: {
                                MangaCard(manga: manga)
                                    .frame(width: (geometry.size.width * 0.5) - 5, height: (geometry.size.width * 0.75))
                                    .cornerRadius(5)
                                    .onAppear {
                                        if (manga.id == vm.list.last?.id) {
                                            vm.next()
                                        }
                                    }
                            }
                        }
                    }
                    
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if (vm.list.isEmpty) {
                    vm.submit(text: "")
                }
            }
        }
    }
}

// MARK: Browse View Model

class BrowseViewModel: ObservableObject {
    @Published var list: [Manga] = []
    private var offset = 0
    private var text = ""
    
    // Send request
    private func send() -> Void {
        DispatchQueue.main.async {
            Task {
                do {
                    self.list.append(contentsOf: try await Mangadex.getSearchResult(title: self.text, offset: self.offset))
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
    func next() -> Void {
        self.offset += 1
        self.send()
    }
}

// MARK: Preview

#Preview {
    BrowseView()
}
