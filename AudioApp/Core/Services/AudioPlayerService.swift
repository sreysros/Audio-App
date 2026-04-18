//
//  AudioPlayerProtocol.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import Foundation
import AVFoundation
import Combine

// MARK: - Audio Player Protocol (for testability)
protocol AudioPlayerProtocol: ObservableObject {
    var currentBook: Audiobook? { get }
    var isPlaying: Bool { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    var progress: Double { get }
    var playbackRate: Float { get }
    
    func play(audiobook: Audiobook)
    func togglePlayPause()
    func seek(to progress: Double)
    func skipForward(seconds: Double)
    func skipBackward(seconds: Double)
    func setPlaybackRate(_ rate: Float)
    func stop()
}

// MARK: - Audio Player Service
final class AudioPlayerService: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var currentBook: Audiobook?
    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var progress: Double = 0
    @Published var playbackRate: Float = 1.0
    @Published var isBuffering: Bool = false
    @Published var volume: Float = 1.0
    @Published var isMiniPlayerVisible: Bool = false
    
    // MARK: - Private
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Available Playback Rates
    let availableRates: [Float] = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    deinit {
        removeTimeObserver()
    }
    
    // MARK: - Setup
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.allowBluetooth, .allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            print("AudioSession setup failed: \(error)")
        }
    }
    
    // MARK: - Playback Controls
    func play(audiobook: Audiobook) {
        guard let urlString = audiobook.audioURL,
              let url = URL(string: urlString) else {
            // Demo mode: simulate playback with mock data
            currentBook = audiobook
            duration = audiobook.duration
            isPlaying = true
            isMiniPlayerVisible = true
            simulateMockPlayback()
            return
        }
        
        stop()
        
        currentBook = audiobook
        isBuffering = true
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.rate = playbackRate
        
        addTimeObserver()
        observePlayerItem(playerItem)
        
        player?.play()
        isPlaying = true
        isMiniPlayerVisible = true
    }
    
    func togglePlayPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func seek(to progress: Double) {
        let targetTime = progress * duration
        let cmTime = CMTime(seconds: targetTime, preferredTimescale: 1000)
        player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
        self.currentTime = targetTime
        self.progress = progress
    }
    
    func skipForward(seconds: Double = 30) {
        let newTime = min(currentTime + seconds, duration)
        seek(to: newTime / duration)
    }
    
    func skipBackward(seconds: Double = 15) {
        let newTime = max(currentTime - seconds, 0)
        seek(to: newTime / duration)
    }
    
    func setPlaybackRate(_ rate: Float) {
        playbackRate = rate
        player?.rate = isPlaying ? rate : 0
    }
    
    func setVolume(_ value: Float) {
        volume = value
        player?.volume = value
    }
    
    func stop() {
        player?.pause()
        removeTimeObserver()
        player = nil
        isPlaying = false
        currentTime = 0
        progress = 0
    }
    
    // MARK: - Private Helpers
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            if self.duration > 0 {
                self.progress = self.currentTime / self.duration
            }
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    private func observePlayerItem(_ item: AVPlayerItem) {
        item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .readyToPlay:
                    self.duration = item.duration.seconds
                    self.isBuffering = false
                case .failed:
                    self.isBuffering = false
                    print("Player item failed: \(String(describing: item.error))")
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        item.publisher(for: \.isPlaybackBufferEmpty)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEmpty in
                self?.isBuffering = isEmpty
            }
            .store(in: &cancellables)
    }
    
    // Mock playback for demo (no real audio URL)
    private var mockTimer: Timer?
    
    private func simulateMockPlayback() {
        mockTimer?.invalidate()
        mockTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            self.currentTime += 0.5
            if self.duration > 0 {
                self.progress = self.currentTime / self.duration
            }
            if self.currentTime >= self.duration {
                self.isPlaying = false
                self.mockTimer?.invalidate()
            }
        }
    }
    
    // MARK: - Formatting Helpers
    func formattedTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }
}
