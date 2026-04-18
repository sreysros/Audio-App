//
//  LibraryViewModel.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//
import Foundation
import Combine

final class LibraryViewModel: ObservableObject {
    
    @Published var books: [Audiobook] = []
    @Published var continueListening: [Audiobook] = []
    
    func onAppear() {
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            books = Audiobook.mock
            continueListening = Array(Audiobook.mock.prefix(1))
        }
    }
}
