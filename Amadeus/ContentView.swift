// Project: Amadeus
// Created By: Thadisha Thilakaratne

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: TabType = .library

    var body: some View {
        TabView(selection: $selection) {
            ReadingView()
                .tabItem {Label("Reading", systemImage: "book")}
                .tag(TabType.reading)
            
            LibraryView()
                .tabItem {Label("Library", systemImage: "books.vertical")}
                .tag(TabType.library)
            
            BrowseView()
                .tabItem {Label("Browse", systemImage: "magnifyingglass")}
                .tag(TabType.browse)
            
            SettingsView()
                .tabItem {Label("Settings", systemImage: "gear")}
                .tag(TabType.settings)
            
        }
    }
}

private enum TabType {
    case reading
    case library
    case browse
    case settings
}

#Preview {
    ContentView()
}
