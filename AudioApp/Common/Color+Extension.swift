//
//  PressEffectModifier.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//


import SwiftUI

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static var primaryColor: Color {
        return Color.init(hex: "FF4D00")
    }
    
    static var accentColor: Color {
        return Color.init(hex: "FF8C00")
    }
    
    static var backgroundColor: Color {
        return Color.init(hex: "0A0A0E")
    }
    
    static var surfaceColor: Color {
        return Color(red: 255, green: 255, blue: 255).opacity(0.05-0.1)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
    
    func glassBackground(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
    
    func pressEffect(scale: CGFloat = 0.96) -> some View {
        self.modifier(PressEffectModifier(scale: scale))
    }
}

// MARK: - Press Effect Modifier
struct PressEffectModifier: ViewModifier {
    @GestureState private var isPressed = false
    let scale: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
            )
    }
}

// MARK: - TimeInterval Formatter
extension TimeInterval {
    var formattedDuration: String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }
}
