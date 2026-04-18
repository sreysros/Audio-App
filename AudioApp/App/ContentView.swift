//
//  ContentView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
            Group {
                if authViewModel.isSignedIn {
                    MainTabView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                } else {
                    SignInView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.4), value: authViewModel.isSignedIn)
        }
}

#Preview {
    ContentView()
}
