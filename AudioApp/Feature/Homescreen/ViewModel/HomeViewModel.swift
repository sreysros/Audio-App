//
//  HomeViewModel.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import Foundation
import Combine

// MARK: - Home ViewModel
@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Published
    @Published var pickedForYou: [Audiobook] = []
    @Published var trending: [Audiobook] = []
    @Published var newReleases: [Audiobook] = []
    @Published var selectedGenre: Genre? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let repository: AudiobookRepositoryProtocol
    
    init(repository: AudiobookRepositoryProtocol = AudiobookRepository()) {
        self.repository = repository
    }
    
    // MARK: - Intents
    func onAppear() {
        Task {
            await loadContent()
        }
    }
    
    func selectGenre(_ genre: Genre?) {
        selectedGenre = genre
        Task {
            await filterByGenre(genre)
        }
    }
    
    func refresh() {
        Task {
            await loadContent()
        }
    }
    
    // MARK: - Private
    private func loadContent() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            async let picked = repository.fetchPickedForYou()
            async let trend = repository.fetchTrending()
            async let newR = repository.fetchNewReleases()
            
            let (p, t, n) = try await (picked, trend, newR)
            pickedForYou = p
            trending = t
            newReleases = n
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func filterByGenre(_ genre: Genre?) async {
        guard let genre = genre else {
            await loadContent()
            return
        }
        isLoading = true
        defer { isLoading = false }
        
        do {
            pickedForYou = try await repository.fetchByGenre(genre)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
