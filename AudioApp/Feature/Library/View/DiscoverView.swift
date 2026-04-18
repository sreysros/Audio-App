//
//  DiscoverView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @State private var searchText = ""
    @State private var searchResults: [Audiobook] = []
    @State private var isSearching = false
    @State private var selectedBook: Audiobook?
    @State private var showDetail = false
    private let repository: AudiobookRepositoryProtocol = AudiobookRepository()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Discover")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Search bar
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.4))
                                .font(.system(size: 16))
                            
                            TextField("Search titles, authors...", text: $searchText)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .tint(Color.primaryColor)
//                                .onChange(of: searchText) { _, newValue in
//                                    performSearch(query: newValue)
//                                }
                        }
                        .padding(14)
                        .background(Color.white.opacity(0.07))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    .padding(.bottom, 20)
                    
                    // Results
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(searchResults.isEmpty && searchText.isEmpty ? Audiobook.mock : searchResults) { book in
                                Button(action: {
                                    selectedBook = book
                                    showDetail = true
                                }) {
                                    SearchResultRow(audiobook: book)
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                    .background(Color.white.opacity(0.06))
                                    .padding(.leading, 80)
                            }
                        }
                        .padding(.horizontal, 20)
                        Spacer().frame(height: audioPlayerService.isMiniPlayerVisible ? 160 : 80)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showDetail) {
                if let book = selectedBook { BookDetailView(audiobook: book) }
            }
        }
    }
    
    private func performSearch(query: String) {
        Task {
            let results = try? await repository.searchAudiobooks(query: query)
            await MainActor.run {
                searchResults = results ?? []
            }
        }
    }
}
