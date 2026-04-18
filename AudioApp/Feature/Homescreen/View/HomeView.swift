//
//  HomeView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedBook: Audiobook?
    @State private var showDetail: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.backgroundColor.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        // Hero Banner Carousel
                        HeroBannerCarousel()
                            .padding(.top, 8)
                        
                        // Genres Section
                        GenreScrollSection(
                            selectedGenre: $viewModel.selectedGenre,
                            onSelect: viewModel.selectGenre
                        )
                        
                        // Picked For You
                        if !viewModel.pickedForYou.isEmpty {
                            BookCarouselSection(
                                title: "Picked For You",
                                emoji: "🔥",
                                books: viewModel.pickedForYou,
                                onTap: { book in
                                    selectedBook = book
                                    showDetail = true
                                }
                            )
                        }
                        
                        // Trending
                        if !viewModel.trending.isEmpty {
                            BookCarouselSection(
                                title: "Trending Now",
                                emoji: "📈",
                                books: viewModel.trending,
                                onTap: { book in
                                    selectedBook = book
                                    showDetail = true
                                }
                            )
                        }
                        
                        // New Releases
                        if !viewModel.newReleases.isEmpty {
                            BookCarouselSection(
                                title: "New Releases",
                                emoji: "✨",
                                books: viewModel.newReleases,
                                onTap: { book in
                                    selectedBook = book
                                    showDetail = true
                                }
                            )
                        }
                        
                        // Bottom space for mini player
                        Spacer().frame(height: audioPlayerService.isMiniPlayerVisible ? 160 : 80)
                    }
                }
                .refreshable { viewModel.refresh() }
                
                // Top Navigation Bar
                HomeNavigationBar()
                    .background(
                        LinearGradient(
                            colors: [Color.backgroundColor, Color.backgroundColor.opacity(0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)
                        .ignoresSafeArea()
                    )
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showDetail) {
                if let book = selectedBook {
                    BookDetailView(audiobook: book)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .overlay(alignment: .center) {
            if viewModel.isLoading && viewModel.pickedForYou.isEmpty {
                LoadingView()
            }
        }
    }
}

// MARK: - Home Navigation Bar
struct HomeNavigationBar: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack(spacing: 14) {
            // Profile avatar
            RemoteImage(urlString: authViewModel.currentUser?.profileImageURL)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.primaryColor.opacity(0.5), lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 1) {
                Text("Morning, \(authViewModel.currentUser?.firstName ?? "there")")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Search
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            
            // Notifications
            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                    
                    Circle()
                        .fill(Color.primaryColor)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 12)
    }
}

// MARK: - Hero Banner Carousel
struct HeroBannerCarousel: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    let banners = [
        BannerItem(
            title: "Explore Over 1M+\nAudiobooks ✨",
            subtitle: "Start listening today",
            ctaTitle: "Join Now",
            gradient: [Color.primaryColor, Color.accentColor, Color(hex: "FFB347")],
            systemIcon: "headphones"
        ),
        BannerItem(
            title: "New Titles\nEvery Week 🎧",
            subtitle: "Fresh stories, always",
            ctaTitle: "Browse",
            gradient: [Color(hex: "6A3DE8"), Color(hex: "9B59B6"), Color(hex: "C39BD3")],
            systemIcon: "waveform"
        ),
        BannerItem(
            title: "Listen Offline\nAnywhere 🌍",
            subtitle: "Download & go",
            ctaTitle: "Try Free",
            gradient: [Color(hex: "00B4D8"), Color(hex: "0077B6"), Color(hex: "023E8A")],
            systemIcon: "arrow.down.circle.fill"
        )
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            TabView(selection: $currentIndex) {
                ForEach(banners.indices, id: \.self) { index in
                    BannerCard(banner: banners[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 170)
            .padding(.horizontal, 20)
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 0.6)) {
                    currentIndex = (currentIndex + 1) % banners.count
                }
            }
            
            // Page dots
            HStack(spacing: 6) {
                ForEach(banners.indices, id: \.self) { idx in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(idx == currentIndex ? Color.primaryColor : Color.white.opacity(0.25))
                        .frame(width: idx == currentIndex ? 18 : 6, height: 4)
                        .animation(.spring(response: 0.3), value: currentIndex)
                }
            }
        }
    }
}

struct BannerItem {
    let title: String
    let subtitle: String
    let ctaTitle: String
    let gradient: [Color]
    let systemIcon: String
}

struct BannerCard: View {
    let banner: BannerItem
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background gradient
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: banner.gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 180, height: 180)
                .offset(x: 160, y: -40)
            
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 120, height: 120)
                .offset(x: 220, y: 60)
            
            // Icon
            Image(systemName: banner.systemIcon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(.white.opacity(0.15))
                .offset(x: 190, y: 0)
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text(banner.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Text(banner.ctaTitle)
                            .font(.system(size: 13, weight: .semibold))
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.25))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.25), lineWidth: 1))
                }
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

// MARK: - Genre Scroll Section
struct GenreScrollSection: View {
    @Binding var selectedGenre: Genre?
    let onSelect: (Genre?) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Genres", emoji: "🔥")
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // All genres pill
                    GenrePill(
                        title: "All",
                        icon: "square.grid.2x2.fill",
                        isSelected: selectedGenre == nil
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            onSelect(nil)
                        }
                    }
                    
                    ForEach(Genre.allCases) { genre in
                        GenrePill(
                            title: genre.rawValue,
                            icon: genre.icon,
                            isSelected: selectedGenre == genre
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                onSelect(genre)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct GenrePill: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : Color.white.opacity(0.6))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected
                    ? Color.primaryColor.opacity(0.9)
                    : Color.white.opacity(0.07)
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.clear : Color.white.opacity(0.1),
                        lineWidth: 1
                    )
            )
        }
    }
}

// MARK: - Book Carousel Section
struct BookCarouselSection: View {
    let title: String
    let emoji: String
    let books: [Audiobook]
    let onTap: (Audiobook) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: title, emoji: emoji)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(books) { book in
                        BookCard(audiobook: book, onTap: { onTap(book) })
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Book Card
struct BookCard: View {
    let audiobook: Audiobook
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Cover
                RemoteImage(
                    urlString: audiobook.coverImageURL,
                    placeholder: AnyView(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                )
                .frame(width: 130, height: 175)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.4), radius: 8, y: 6)
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(.spring(response: 0.25), value: isPressed)
                
                // Text
                VStack(alignment: .leading, spacing: 3) {
                    Text(audiobook.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .frame(width: 130, alignment: .leading)
                    
                    Text(audiobook.author)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                        .lineLimit(1)
                        .frame(width: 130, alignment: .leading)
                }
            }
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let emoji: String
    
    var body: some View {
        HStack {
            Text("\(title) \(emoji)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.primaryColor)
            }
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Color.backgroundColor.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [Color.primaryColor, Color.accentColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                
                Text("Loading...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
}
