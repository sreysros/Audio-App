//
//  SearchResultRow.swift
//  AudioApp
//
//  Created by Leak Sreysros on 18/4/26.
//
import SwiftUI

struct SearchResultRow: View {
    let audiobook: Audiobook
    
    var body: some View {
        HStack(spacing: 14) {
            RemoteImage(
                urlString: audiobook.coverImageURL,
                placeholder: AnyView(Color.white.opacity(0.08))
            )
            .frame(width: 52, height: 68)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(audiobook.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(audiobook.author)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
                HStack(spacing: 6) {
                    Text(audiobook.genre.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.primaryColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.primaryColor.opacity(0.12))
                        .clipShape(Capsule())
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", audiobook.rating))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.25))
        }
        .padding(.vertical, 12)
    }
}
