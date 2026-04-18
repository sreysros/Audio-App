//
//  User.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let profileImageURL: String?
    var libraryBookIDs: [String]
    var favoriteBookIDs: [String]
    
    var firstName: String {
        name.components(separatedBy: " ").first ?? name
    }
    
    static let mock = User(
        id: "user_1",
        name: "Yulia Petrova",
        email: "yulia@example.com",
        profileImageURL: "https://i.pravatar.cc/150?img=47",
        libraryBookIDs: ["1", "2", "3"],
        favoriteBookIDs: ["2", "4"]
    )
}
