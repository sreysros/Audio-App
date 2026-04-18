//
//  AudioAppApp.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//

import SwiftUI
import GoogleSignIn

@main
struct AudioAppApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var audioPlayerService = AudioPlayerService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(audioPlayerService)
                .preferredColorScheme(.dark)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    authViewModel.restorePreviousSignIn()
                }
        }
    }
}
