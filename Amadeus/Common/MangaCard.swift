// Project: Amadeus
// Created By: Thadisha Thilakaratne

import SwiftUI

struct MangaCard: View {
    // State
    @StateObject private var vm: CardViewModel
    
    // Constructor
    init(manga: Manga) {
        _vm = StateObject(wrappedValue: CardViewModel(manga: manga))
    }
    
    var body: some View {
        VStack {
            if let image = vm.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay {
                         GeometryReader { geometry in
                             Rectangle()
                                 .foregroundColor(Color.black.opacity(0.8))
                                 .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                                 .overlay {
                                     Text(self.vm.manga.title!)
                                         .font(Font.callout.weight(.semibold))
                                         .padding(10)
                                         .foregroundColor(.white)
                                 }
                                 .offset(y: geometry.size.height * 0.75)
                         }
                     }
            } else {
                ProgressView()
            }
        }
    }
}

// MARK: Card View Model

class CardViewModel: ObservableObject {
    @Published var manga: Manga
    @Published var image: Image?
    
    // Constructor
    init(manga: Manga) {
        self.manga = manga
        
        // Get image locally
        if let cover = manga.cover, let uiImage = UIImage(data: cover) {
            self.image = Image(uiImage: uiImage)
        }
        
        // Get image from URL if not available locally
        else if let coverURL = manga.coverURL {
            URLSession.shared.dataTask(with: coverURL) { [weak self] data, response, error in
                guard let self = self else { return }

                if let data = data, error == nil, let uiImage = UIImage(data: data) {
                    // Ensure UI update is on main thread
                    DispatchQueue.main.async {
                        self.manga.cover = data
                        self.image = Image(uiImage: uiImage)
                    }
                }
            }.resume()
        }
    }
}
