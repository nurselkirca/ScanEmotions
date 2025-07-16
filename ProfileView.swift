//
//  ProfilView.swift
//  ScanEmotion
//
//  Created by Nursel Kırca on 15.06.2025.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("email") var email: String = ""
    @State private var emotionStats: [String: Float] = [:]
    @State private var mostFrequentEmotion: String = ""
    @State private var highestAvgPercent: Float = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Profil")
                .font(.largeTitle)
                .bold()

            Text("E-posta: \(email)")

            Divider()

            Text("Geçmiş Analiz Özeti")
                .font(.headline)

            if emotionStats.isEmpty {
                Text("Henüz veri yok.")
            } else {
                ForEach(emotionStats.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                    Text("\(key): %\(String(format: "%.1f", value * 100)) ort.")
                }

                Divider()

                Text("En Çok Gözlemlenen Duygu")
                    .font(.subheadline)
                    .bold()

                Text("\(mostFrequentEmotion) (%\(String(format: "%.1f", highestAvgPercent * 100)))")
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            calculateEmotionStats()
        }
    }

    func calculateEmotionStats() {
        guard let history = UserDefaults.standard.array(forKey: "emotionHistory") as? [[String: Float]] else { return }

        var sums: [String: Float] = [:]
        var counts: [String: Int] = [:]

        for entry in history {
            for (emotion, value) in entry {
                sums[emotion, default: 0] += value
                counts[emotion, default: 0] += 1
            }
        }

        var averages: [String: Float] = [:]
        for (emotion, sum) in sums {
            if let count = counts[emotion] {
                averages[emotion] = sum / Float(count)
            }
        }

        self.emotionStats = averages

        if let (topEmotion, topAvg) = averages.max(by: { $0.value < $1.value }) {
            mostFrequentEmotion = topEmotion
            highestAvgPercent = topAvg
        }
    }
}

