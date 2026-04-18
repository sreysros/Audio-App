//
//  FavoritesView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @State private var favorites: [Audiobook] = Array(Audiobook.mock.prefix(3))
    @State private var selectedBook: Audiobook?
    @State private var showDetail = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Favorites")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.top, 60)
                        
                        if favorites.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "heart.slash")
                                    .font(.system(size: 48))
                                    .foregroundColor(.white.opacity(0.2))
                                Text("No favorites yet")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(favorites) { book in
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
                        }
                        
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
}
