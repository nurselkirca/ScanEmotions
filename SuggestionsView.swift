//
//  SuggestionsView.swift
//  ScanEmotion
//
//  Created by Nursel Kırca on 15.06.2025.
//

import SwiftUI

struct SuggestionsView: View {
    let predictionProbabilities: [String: Float]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Stres Azaltıcı Öneriler")
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            
            let dominantEmotion = getDominantEmotion()
            
            ForEach(suggestions(for: dominantEmotion), id: \.self) { suggestion in
                Text("• \(suggestion)")
                    .font(.body)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Öneriler")
    }
    
    // En yüksek olasılığa sahip duygu
    func getDominantEmotion() -> String {
        predictionProbabilities.max(by: { $0.value < $1.value })?.key.lowercased() ?? ""
    }
    
    // Duyguya göre öneriler
    func suggestions(for emotion: String) -> [String] {
        if emotion.contains("kızgın") || emotion.contains("korku") || emotion.contains("üzgün") || emotion.contains("iğrenme") {
            return [
                "5 dakika derin nefes egzersizi yap",
                "Doğada yürüyüşe çık",
                "Meditasyon müziği dinle",
                "Telefonu 1 saatliğine kapat"
            ]
        } else if emotion.contains("mutlu") || emotion.contains("şaşkın") {
            return [
                "Bu anın tadını çıkar :)",
                "Motive edici müzik aç",
                "Günlüğüne pozitif bir not yaz"
            ]
        } else {
            return ["Stres seviyen dengede görünüyor."]
        }
    }
}
