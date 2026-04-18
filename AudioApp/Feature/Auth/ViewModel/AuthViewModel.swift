//
//  AuthViewModel.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI
import GoogleSignIn
import Combine

// MARK: - Auth ViewModel
@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var isSignedIn: Bool = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let clientID = "243163717472-gnqnfumhf9ge1narninc8acr5efctptp.apps.googleusercontent.com" // Replace with actual client ID
    
    // MARK: - Restore Session
    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            Task { @MainActor in
                if let user = user {
                    self?.handleGoogleUser(user)
                } else {
                    // Use mock user for demo
                     self?.isSignedIn = false
                    // For demo purposes, auto sign-in:
//                    self?.signInWithMock()
                }
            }
        }
    }
    
    // MARK: - Google Sign-In
    func signInWithGoogle() {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: path),
                  let clientID = plist["CLIENT_ID"] as? String else {
                errorMessage = "Missing GoogleService-Info.plist"
                return
            }

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootVC = windowScene.windows.first?.rootViewController else { return }

            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootVC = windowScene.windows.first?.rootViewController else {
//            errorMessage = "Unable to find root view controller."
//            return
//        }
        
        isLoading = true
        errorMessage = nil
        
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            Task { @MainActor in
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                if let user = result?.user {
                    self?.handleGoogleUser(user)
                }
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        isSignedIn = false
        currentUser = nil
    }
    
    // MARK: - Mock Sign In (for demo / simulator)
    func signInWithMock() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.currentUser = User.mock
            self?.isSignedIn = true
            self?.isLoading = false
        }
    }
    
    // MARK: - Private
    private func handleGoogleUser(_ googleUser: GIDGoogleUser) {
        let profile = googleUser.profile
        let user = User(
            id: googleUser.userID ?? UUID().uuidString,
            name: profile?.name ?? "User",
            email: profile?.email ?? "",
            profileImageURL: profile?.imageURL(withDimension: 200)?.absoluteString,
            libraryBookIDs: [],
            favoriteBookIDs: []
        )
        currentUser = user
        isSignedIn = true
    }
}
