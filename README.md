# Audio-App
You will can listen to your favorite books anytime, search, sign In with google account.

AudiobookApp - SwiftUI Clean Architecture
Project Structure
AudiobookApp/
├── App/
│   ├── AudiobookApp.swift          # @main entry point
│   ├── RootView.swift              # Auth state router
│   └── MainTabView.swift           # Tab bar + navigation
│
├── Core/                           # Business logic (no SwiftUI)
│   ├── Models/
│   │   ├── Audiobook.swift         # Audiobook & Genre models
│   │   └── User.swift              # User model
│   ├── Services/
│   │   ├── AudioPlayerService.swift # AVFoundation player
│   │   └── ImageLoaderService.swift # URLSession image cache
│   └── Repositories/
│       └── AudiobookRepository.swift # Data layer protocol + impl
│
├── Features/
│   ├── Auth/
│   │   ├── ViewModels/AuthViewModel.swift
│   │   └── Views/SignInView.swift
│   ├── Home/
│   │   ├── ViewModels/HomeViewModel.swift
│   │   └── Views/
│   │       ├── HomeView.swift       # Main screen (carousel, genres)
│   │       └── BookDetailView.swift
│   ├── Player/
│   │   └── Views/PlayerViews.swift  # MiniPlayer + FullPlayer
│   └── Library/
│       └── Views/LibraryViews.swift # Library, Discover, Favorites
│
└── Common/
    └── Extensions/Extensions.swift  # Color(hex:), View modifiers
Architecture
Clean Architecture + MVVM:

Core Layer: Models, Services, Repositories — no UI dependencies
Repository Pattern: AudiobookRepositoryProtocol abstracts data source
MVVM: Each Feature has a ViewModel with @Published state
DI-ready: Protocols allow easy mock injection for testing

Features Implemented
✅ Navigation

NavigationStack with navigationDestination (iOS 16+)
Proper back navigation from detail views
Sheet presentation for Full Player

✅ Custom Tab Bar

4 tabs: Home, Library, Discover, Favorites
Animated selection indicator
Integrates with mini player above

✅ Carousels

Auto-advancing hero banner with page dots
Horizontal scroll carousels for book sections
Smooth spring animations

✅ Image Download

ImageLoader using URLSession + Combine
NSCache-backed ImageCache (100MB limit)
Shimmer loading placeholder
RemoteImage SwiftUI view

✅ Audio Player (AudioKit-compatible)

AVAudioSession configured for background playback + Bluetooth
Play, pause, seek, skip ±15/30 sec
Playback speed control (0.5×–2×)
Progress tracking with periodic observer
Mock playback mode for demo (no audio URL needed)
Mini player + Full player

✅ Google Sign-In

GoogleSignIn SDK integration
restorePreviousSignIn() on launch
URL handling in onOpenURL
Mock sign-in for simulator/demo

Dependencies (SPM)
Add to Xcode via File → Add Packages:
https://github.com/google/GoogleSignIn-iOS
