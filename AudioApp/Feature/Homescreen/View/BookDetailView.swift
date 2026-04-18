//
//  BookDetailView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI

struct BookDetailView: View {
    let audiobook: Audiobook
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    @State private var headerOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.backgroundColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero cover
                    ZStack(alignment: .bottom) {
                        // Blurred background
                        RemoteImage(urlString: audiobook.coverImageURL)
                            .frame(maxWidth: .infinity)
                            .frame(height: 340)
                            .blur(radius: 60)
                            .opacity(0.6)
                        
                        // Cover image
                        RemoteImage(
                            urlString: audiobook.coverImageURL,
                            placeholder: AnyView(Color.white.opacity(0.08))
                        )
                        .frame(width: 180, height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.5), radius: 24, y: 12)
                        .padding(.bottom, 32)
                        
                        // Fade overlay
                        LinearGradient(
                            colors: [.clear, Color.backgroundColor],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(height: 340)
                    
                    // Book info
                    VStack(spacing: 24) {
                        // Title & Author
                        VStack(spacing: 6) {
                            Text(audiobook.title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text(audiobook.author)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.white.opacity(0.6))
                            
                            HStack(spacing: 12) {
                                Label(audiobook.genre.rawValue, systemImage: audiobook.genre.icon)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color.primaryColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(Color.primaryColor.opacity(0.12))
                                    .clipShape(Capsule())
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", audiobook.rating))
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        // Action buttons
                        HStack(spacing: 14) {
                            // Play Button
                            Button(action: {
                                audioPlayerService.play(audiobook: audiobook)
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 16))
                                    Text("Play")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    LinearGradient(
                                        colors: [Color.primaryColor, Color.accentColor],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                .shadow(color: Color.primaryColor.opacity(0.4), radius: 12, y: 6)
                            }
                            
                            // Favorite Button
                            Button(action: { isFavorite.toggle() }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(isFavorite ? Color.primaryColor : .white)
                                    .frame(width: 52, height: 52)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            
                            // Share button
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: 52, height: 52)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                        }
                        
                        // Stats row
                        HStack(spacing: 0) {
                            StatItem(icon: "clock", value: formatDuration(audiobook.duration), label: "Duration")
                            Divider().frame(height: 36).background(Color.white.opacity(0.1))
                            StatItem(icon: "person.wave.2", value: audiobook.narrator ?? "Unknown", label: "Narrator")
                            Divider().frame(height: 36).background(Color.white.opacity(0.1))
                            StatItem(icon: "star", value: "\(audiobook.rating)", label: "Rating")
                        }
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                        // Description
                        VStack(alignment: .leading, spacing: 10) {
                            Text("About")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(audiobook.description)
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.65))
                                .lineSpacing(5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
            
            // Navigation overlay
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 56)
        }
        .navigationBarHidden(true)
        .onAppear { isFavorite = audiobook.isFavorite }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color.primaryColor)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            Text(label)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }
}
