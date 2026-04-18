//
//  Audiobook.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import Foundation

struct Audiobook: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let author: String
    let narrator: String?
    let genre: Genre
    let coverImageURL: String
    let audioURL: String?
    let duration: TimeInterval
    let rating: Double
    let description: String
    var isFavorite: Bool = false
    var progress: Double = 0.0 // 0.0 - 1.0
    
    static let mock: [Audiobook] = [
        Audiobook(
            id: "1",
            title: "My Name Is Emilia del Valle",
            author: "Isabel Allende",
            narrator: "Ozzie Rodriguez",
            genre: .fiction,
            coverImageURL: "https://covers.openlibrary.org/b/id/14756424-L.jpg",
            audioURL: nil,
            duration: 36000,
            rating: 4.7,
            description: "A sweeping novel of love, family, and identity."
        ),
        Audiobook(
            id: "2",
            title: "Atmosphere",
            author: "Taylor Jenkins Reid",
            narrator: "Julia Whelan",
            genre: .fiction,
            coverImageURL: "https://covers.openlibrary.org/b/id/12818862-L.jpg",
            audioURL: nil,
            duration: 43200,
            rating: 4.8,
            description: "A bold, unforgettable story of ambition and love."
        ),
        Audiobook(
            id: "3",
            title: "Edge of Honor",
            author: "Brad Thor",
            narrator: "Armand Schultz",
            genre: .thriller,
            coverImageURL: "https://covers.openlibrary.org/b/id/8739161-L.jpg",
            audioURL: nil,
            duration: 39600,
            rating: 4.5,
            description: "A pulse-pounding thriller from the master of action."
        ),
        Audiobook(
            id: "4",
            title: "Project Hail Mary",
            author: "Andy Weir",
            narrator: "Ray Porter",
            genre: .sciFi,
            coverImageURL: "https://covers.openlibrary.org/b/id/12553091-L.jpg",
            audioURL: nil,
            duration: 48600,
            rating: 4.9,
            description: "A lone astronaut must save Earth."
        ),
        Audiobook(
            id: "5",
            title: "Atomic Habits",
            author: "James Clear",
            narrator: "James Clear",
            genre: .selfHelp,
            coverImageURL: "https://covers.openlibrary.org/b/id/10521270-L.jpg",
            audioURL: nil,
            duration: 32400,
            rating: 4.8,
            description: "Tiny changes, remarkable results."
        ),
        Audiobook(
            id: "6",
            title: "The Midnight Library",
            author: "Matt Haig",
            narrator: "Carey Mulligan",
            genre: .fiction,
            coverImageURL: "https://covers.openlibrary.org/b/id/10452456-L.jpg",
            audioURL: nil,
            duration: 28800,
            rating: 4.6,
            description: "Between life and death there is a library."
        )
    ]
}

enum Genre: String, Codable, CaseIterable, Identifiable {
    case fiction = "Fiction"
    case thriller = "Thriller"
    case mystery = "Mystery"
    case selfHelp = "Self-Help"
    case sciFi = "Sci-Fi"
    case biography = "Biography"
    case business = "Business"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .fiction: return "books.vertical"
        case .thriller: return "bolt.fill"
        case .mystery: return "magnifyingglass"
        case .selfHelp: return "heart.fill"
        case .sciFi: return "sparkles"
        case .biography: return "person.fill"
        case .business: return "chart.bar.fill"
        }
    }
    
    var emoji: String {
        switch self {
        case .fiction: return "📚"
        case .thriller: return "⚡️"
        case .mystery: return "🔍"
        case .selfHelp: return "💛"
        case .sciFi: return "🚀"
        case .biography: return "🧠"
        case .business: return "💼"
        }
    }
}
