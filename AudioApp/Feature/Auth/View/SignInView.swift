//
//  SignInView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Background
            backgroundLayer
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo & branding
                logoSection
                
                Spacer()
                
                // Sign-in buttons
                signInSection
                
                Spacer().frame(height: 48)
            }
            .padding(.horizontal, 32)
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Background
    private var backgroundLayer: some View {
        ZStack {
            Color.backgroundColor
            
            // Animated gradient blobs
            Circle()
                .fill(Color.primaryColor.opacity(0.25))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: animateGradient ? 80 : -80, y: -200)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: animateGradient)
            
            Circle()
                .fill(Color.accentColor.opacity(0.2))
                .frame(width: 250, height: 250)
                .blur(radius: 60)
                .offset(x: animateGradient ? -60 : 60, y: 100)
                .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: animateGradient)
        }
        .onAppear { animateGradient = true }
    }
    
    // MARK: - Logo Section
    private var logoSection: some View {
        VStack(spacing: 20) {
            // App icon
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryColor, Color.accentColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.primaryColor.opacity(0.5), radius: 20, y: 10)
                
                Image(systemName: "headphones")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Audiobooks")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Over 1 million titles at your fingertips")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    // MARK: - Sign In Section
    private var signInSection: some View {
        VStack(spacing: 16) {
            if authViewModel.isLoading {
                ProgressView()
                    .tint(Color.primaryColor)
                    .scaleEffect(1.5)
                    .frame(height: 56)
            } else {
                // Google Sign-In Button
                Button(action: { authViewModel.signInWithGoogle() }) {
                    HStack(spacing: 12) {
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                        
                        Text("Continue with Google")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                
                // Demo / Mock Sign-In
                Button(action: { authViewModel.signInWithMock() }) {
                    Text("Continue as Guest")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 4)
            }
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(.red.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            
            Text("By continuing, you agree to our Terms & Privacy Policy")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.3))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
    }
}
