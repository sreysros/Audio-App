//
//  Tab.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI

enum Tab: Int, CaseIterable {
    case home = 0
    case library
    case discover
    case favorites
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .library: return "Library"
        case .discover: return "Discover"
        case .favorites: return "Favorites"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .library: return "book.fill"
        case .discover: return "safari.fill"
        case .favorites: return "heart.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @State private var selectedTab: Tab = .home
    @State private var showPlayer: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(Tab.home)
                
                LibraryView()
                    .tag(Tab.library)
                
                DiscoverView()
                    .tag(Tab.discover)
                
                FavoritesView()
                    .tag(Tab.favorites)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Layer stack at bottom
            VStack(spacing: 0) {
                // Mini Player
                if audioPlayerService.isMiniPlayerVisible {
                    MiniPlayerView(showFullPlayer: $showPlayer)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showPlayer) {
            FullPlayerView()
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: audioPlayerService.isMiniPlayerVisible)
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                TabBarButton(tab: tab, isSelected: selectedTab == tab) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            ZStack {
                Color(hex: "111116")
                    .ignoresSafeArea(edges: .bottom)
                
                // Top divider with gradient
                LinearGradient(
                    colors: [Color.white.opacity(0.08), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 1)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        )
    }
}

struct TabBarButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.primaryColor.opacity(0.15))
                            .frame(width: 52, height: 36)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? Color.primaryColor : Color.white.opacity(0.4))
                        .scaleEffect(isSelected ? 1.05 : 1.0)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
