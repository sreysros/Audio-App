//
//  LibraryView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI

// MARK: - Library View
struct LibraryView: View {
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @StateObject private var viewModel = LibraryViewModel()
    @State private var selectedBook: Audiobook?
    @State private var showDetail = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        Text("My Library")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.top, 60)
                        
                        // Continue Listening
                        if let current = viewModel.continueListening.first {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Continue Listening 🎧")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                
                                ContinueListeningCard(audiobook: current) {
                                    audioPlayerService.play(audiobook: current)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // All books
                        Text("All Books")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.books) { book in
                                Button(action: {
                                    selectedBook = book
                                    showDetail = true
                                }) {
                                    BookGridCell(audiobook: book)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer().frame(height: audioPlayerService.isMiniPlayerVisible ? 160 : 80)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showDetail) {
                if let book = selectedBook {
                    BookDetailView(audiobook: book)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
    }
}

struct ContinueListeningCard: View {
    let audiobook: Audiobook
    let onPlay: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            RemoteImage(
                urlString: audiobook.coverImageURL,
                placeholder: AnyView(Color.white.opacity(0.08))
            )
            .frame(width: 70, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(audiobook.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(audiobook.author)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.12)).frame(height: 4)
                        Capsule()
                            .fill(Color.primaryColor)
                            .frame(width: geo.size.width * 0.35, height: 4)
                    }
                }
                .frame(height: 4)
                
                Text("35% complete")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
            }
            
            Spacer()
            
            Button(action: onPlay) {
                ZStack {
                    Circle()
                        .fill(Color.primaryColor)
                        .frame(width: 42, height: 42)
                    Image(systemName: "play.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct BookGridCell: View {
    let audiobook: Audiobook
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RemoteImage(
                urlString: audiobook.coverImageURL,
                placeholder: AnyView(Color.white.opacity(0.08))
            )
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            Text(audiobook.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Text(audiobook.author)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.4))
        }
    }
}
