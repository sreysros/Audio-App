//
//  AudiobookRepositoryProtocol.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import Foundation

// MARK: - Repository Protocol (Clean Architecture)
protocol AudiobookRepositoryProtocol {
    func fetchPickedForYou() async throws -> [Audiobook]
    func fetchTrending() async throws -> [Audiobook]
    func fetchNewReleases() async throws -> [Audiobook]
    func fetchByGenre(_ genre: Genre) async throws -> [Audiobook]
    func fetchLibrary(userID: String) async throws -> [Audiobook]
    func toggleFavorite(audiobook: Audiobook) async throws -> Audiobook
    func searchAudiobooks(query: String) async throws -> [Audiobook]
}

// MARK: - Repository Implementation
final class AudiobookRepository: AudiobookRepositoryProtocol {
    
    // In a real app, this would call a network layer or local DB.
    // Here we simulate async operations with mock data.
    
    private let allBooks = Audiobook.mock
    
    func fetchPickedForYou() async throws -> [Audiobook] {
        try await simulateNetworkDelay()
        return Array(allBooks.shuffled().prefix(6))
    }
    
    func fetchTrending() async throws -> [Audiobook] {
        try await simulateNetworkDelay()
        return Array(allBooks.sorted { $0.rating > $1.rating }.prefix(4))
    }
    
    func fetchNewReleases() async throws -> [Audiobook] {
        try await simulateNetworkDelay()
        return Array(allBooks.reversed().prefix(4))
    }
    
    func fetchByGenre(_ genre: Genre) async throws -> [Audiobook] {
        try await simulateNetworkDelay()
        let filtered = allBooks.filter { $0.genre == genre }
        return filtered.isEmpty ? allBooks : filtered
    }
    
    func fetchLibrary(userID: String) async throws -> [Audiobook] {
        try await simulateNetworkDelay()
        return Array(allBooks.prefix(4))
    }
    
    func toggleFavorite(audiobook: Audiobook) async throws -> Audiobook {
        var updated = audiobook
        updated.isFavorite.toggle()
        return updated
    }
    
    func searchAudiobooks(query: String) async throws -> [Audiobook] {
        try await simulateNetworkDelay(0.3)
        guard !query.isEmpty else { return allBooks }
        return allBooks.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.author.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Private
    private func simulateNetworkDelay(_ duration: Double = 0.5) async throws {
        try await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
}

// MARK: - Mock Repository (for previews/tests)
final class MockAudiobookRepository: AudiobookRepositoryProtocol {
    func fetchPickedForYou() async throws -> [Audiobook] { Audiobook.mock }
    func fetchTrending() async throws -> [Audiobook] { Audiobook.mock }
    func fetchNewReleases() async throws -> [Audiobook] { Audiobook.mock }
    func fetchByGenre(_ genre: Genre) async throws -> [Audiobook] { Audiobook.mock }
    func fetchLibrary(userID: String) async throws -> [Audiobook] { Audiobook.mock }
    func toggleFavorite(audiobook: Audiobook) async throws -> Audiobook { audiobook }
    func searchAudiobooks(query: String) async throws -> [Audiobook] { Audiobook.mock }
}
