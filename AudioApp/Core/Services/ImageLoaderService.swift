//
//  ImageCache.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI
import Combine

// MARK: - Image Cache
final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 200
        cache.totalCostLimit = 100 * 1024 * 1024 // 100 MB
    }
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString, cost: Int(image.size.width * image.size.height * 4))
    }
}

// MARK: - Image Loader
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading: Bool = false
    
    private var cancellable: AnyCancellable?
    private let url: URL?
    
    init(urlString: String?) {
        if let urlString = urlString {
            self.url = URL(string: urlString)
        } else {
            self.url = nil
        }
    }
    
    func load() {
        guard let url = url else { return }
        let key = url.absoluteString
        
        if let cached = ImageCache.shared.image(forKey: key) {
            self.image = cached
            return
        }
        
        isLoading = true
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.isLoading = false
                if let image = image {
                    ImageCache.shared.setImage(image, forKey: key)
                    self?.image = image
                }
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

// MARK: - Async Remote Image View
struct RemoteImage: View {
    @StateObject private var loader: ImageLoader
    let placeholder: AnyView
    
    init(urlString: String?, placeholder: AnyView = AnyView(Color.gray.opacity(0.3))) {
        _loader = StateObject(wrappedValue: ImageLoader(urlString: urlString))
        self.placeholder = placeholder
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if loader.isLoading {
                ZStack {
                    placeholder
                    ProgressView()
                        .tint(.white.opacity(0.5))
                }
            } else {
                placeholder
            }
        }
    }
}

// MARK: - Convenience Modifier
extension View {
    func shimmer(isActive: Bool) -> some View {
        self.overlay(
            Group {
                if isActive {
                    ShimmerView()
                }
            }
        )
    }
}

struct ShimmerView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: phase - 0.2),
                .init(color: .white.opacity(0.12), location: phase),
                .init(color: .clear, location: phase + 0.2)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .onAppear {
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                phase = 1.2
            }
        }
    }
}
