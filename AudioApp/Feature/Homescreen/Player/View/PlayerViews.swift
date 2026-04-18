//
//  MiniPlayerView.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI

// MARK: - Mini Player
struct MiniPlayerView: View {
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @Binding var showFullPlayer: Bool
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 12) {
            // Cover
            RemoteImage(
                urlString: audioPlayerService.currentBook?.coverImageURL,
                placeholder: AnyView(Color.white.opacity(0.1))
            )
            .frame(width: 44, height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            // Title & Author
            VStack(alignment: .leading, spacing: 2) {
                Text(audioPlayerService.currentBook?.title ?? "")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(audioPlayerService.currentBook?.author ?? "")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Skip back
            Button(action: { audioPlayerService.skipBackward() }) {
                Image(systemName: "gobackward.15")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Play/Pause
            Button(action: { audioPlayerService.togglePlayPause() }) {
                ZStack {
                    Circle()
                        .fill(Color.primaryColor)
                        .frame(width: 38, height: 38)
                    Image(systemName: audioPlayerService.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                }
            }
            
            // Skip forward
            Button(action: { audioPlayerService.skipForward() }) {
                Image(systemName: "goforward.30")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                Color(hex: "1C1C22")
                
                // Progress bar at top
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color.primaryColor)
                        .frame(width: geo.size.width * audioPlayerService.progress, height: 2)
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 4)
        .onTapGesture { showFullPlayer = true }
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height < -40 {
                        showFullPlayer = true
                    }
                    withAnimation(.spring(response: 0.35)) {
                        dragOffset = 0
                    }
                }
        )
    }
}

// MARK: - Full Player
struct FullPlayerView: View {
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @Environment(\.dismiss) private var dismiss
    @State private var showSpeedSheet = false
    
    var body: some View {
        ZStack {
            // Background with blurred cover
            ZStack {
                Color.backgroundColor
                
                RemoteImage(urlString: audioPlayerService.currentBook?.coverImageURL)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .blur(radius: 80)
                    .opacity(0.4)
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Handle
                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 36, height: 4)
                    .padding(.top, 12)
                
                // Nav
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Now Playing")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                // Album art
                RemoteImage(
                    urlString: audioPlayerService.currentBook?.coverImageURL,
                    placeholder: AnyView(Color.white.opacity(0.1))
                )
                .frame(width: 260, height: 340)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.5), radius: 30, y: 20)
                .scaleEffect(audioPlayerService.isPlaying ? 1.0 : 0.92)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: audioPlayerService.isPlaying)
                
                Spacer()
                
                VStack(spacing: 28) {
                    // Title
                    VStack(spacing: 6) {
                        Text(audioPlayerService.currentBook?.title ?? "")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text(audioPlayerService.currentBook?.author ?? "")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    // Progress
                    VStack(spacing: 8) {
                        // Scrubber
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 4)
                                
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.primaryColor, Color.accentColor],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geo.size.width * audioPlayerService.progress, height: 4)
                                
                                Circle()
                                    .fill(.white)
                                    .frame(width: 16, height: 16)
                                    .shadow(color: Color.primaryColor.opacity(0.4), radius: 4)
                                    .offset(x: geo.size.width * audioPlayerService.progress - 8)
                            }
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let progress = value.location.x / geo.size.width
                                        audioPlayerService.seek(to: max(0, min(1, progress)))
                                    }
                            )
                        }
                        .frame(height: 16)
                        
                        HStack {
                            Text(audioPlayerService.formattedTime(audioPlayerService.currentTime))
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                            Spacer()
                            Text("-" + audioPlayerService.formattedTime(audioPlayerService.duration - audioPlayerService.currentTime))
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }
                    
                    // Controls
                    HStack(spacing: 36) {
                        // Speed
                        Button(action: { showSpeedSheet = true }) {
                            Text("\(String(format: audioPlayerService.playbackRate == 1.0 ? "%.0f" : "%.2g", audioPlayerService.playbackRate))×")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        // Skip back 15
                        Button(action: { audioPlayerService.skipBackward(seconds: 15) }) {
                            Image(systemName: "gobackward.15")
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        // Play/Pause
                        Button(action: { audioPlayerService.togglePlayPause() }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.primaryColor, Color.accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.primaryColor.opacity(0.4), radius: 16, y: 8)
                                
                                Image(systemName: audioPlayerService.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                                    .offset(x: audioPlayerService.isPlaying ? 0 : 2)
                            }
                        }
                        
                        // Skip forward 30
                        Button(action: { audioPlayerService.skipForward(seconds: 30) }) {
                            Image(systemName: "goforward.30")
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        // Sleep timer
                        Button(action: {}) {
                            Image(systemName: "moon.zzz")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(.horizontal, 28)
                
                Spacer().frame(height: 48)
            }
        }
        .sheet(isPresented: $showSpeedSheet) {
            SpeedSelectorSheet()
                .presentationDetents([.fraction(0.35)])
        }
    }
}

// MARK: - Speed Selector
struct SpeedSelectorSheet: View {
    @EnvironmentObject var audioPlayerService: AudioPlayerService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Playback Speed")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top, 16)
            
            HStack(spacing: 10) {
                ForEach(audioPlayerService.availableRates, id: \.self) { rate in
                    Button(action: {
                        audioPlayerService.setPlaybackRate(rate)
                        dismiss()
                    }) {
                        Text("\(String(format: rate == 1.0 ? "%.0f" : "%.2g", rate))×")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(audioPlayerService.playbackRate == rate ? .white : Color.white.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(
                                audioPlayerService.playbackRate == rate
                                    ? Color(hex: "FF4D00")
                                    : Color.white.opacity(0.08)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color(hex: "1A1A22").ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}
