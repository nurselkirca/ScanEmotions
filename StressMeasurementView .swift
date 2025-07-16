//
//  StressMeasurementView .swift
//  ScanEmotion
//
//  Created by Nursel Kırca on 15.06.2025.
//

import SwiftUI

struct StressMeasurementView: View {
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var predictionProbabilities: [String: Float] = [:]
    @State private var showDetails = false
    @State private var showSuggestions = false

    var body: some View {
        VStack(spacing: 20) {
            if image == nil {
                Button("Fotoğraf Çek") {
                    showImagePicker = true
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            } else {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)

                if let maxEntry = predictionProbabilities.max(by: { $0.value < $1.value }) {
                    let stressLevel = mapEmotionToStressLevel(emotion: maxEntry.key)

                    Text("En Yüksek Duygu: \(maxEntry.key) - \(String(format: "%.2f", maxEntry.value * 100))%")
                        .font(.headline)
                        .padding(.top)

                    Text("Stres Seviyesi: \(stressLevel)")
                        .font(.subheadline)
                        .foregroundColor(stressLevelColor(stressLevel))
                }

                Button(showDetails ? "Detayları Gizle" : "Detaylar") {
                    withAnimation {
                        showDetails.toggle()
                    }
                }
                .padding(.top, 5)

                if showDetails {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(predictionProbabilities.sorted(by: { $0.value > $1.value }), id: \.key) { label, prob in
                            Text("\(label): \(String(format: "%.2f", prob * 100))%")
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                }

                Button("Öneriler") {
                    showSuggestions = true
                }
                .font(.title3)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.top)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Stres Ölçümü")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .camera, image: $image, onImagePicked: classifyImage)
                .ignoresSafeArea()
        }
        .background(
            NavigationLink(destination: SuggestionsView(predictionProbabilities: predictionProbabilities), isActive: $showSuggestions) {
                EmptyView()
            }
        )
    }

    func classifyImage(_ uiImage: UIImage) {
        guard let inputArray = imageToMultiArray(image: uiImage) else {
            predictionProbabilities = ["Hata": 1.0]
            return
        }

        do {
            let model = try EmotionModel()
            let prediction = try model.prediction(inputs: inputArray)
            let raw = prediction.Identity
            let logits = (0..<raw.count).map { raw[$0].floatValue }
            let expValues = logits.map { exp($0) }
            let sumExp = expValues.reduce(0, +)
            let probabilities = expValues.map { $0 / sumExp }

            let labels = ["Kızgın", "İğrenme", "Korku", "Mutlu", "Üzgün", "Şaşkın", "Nötr"]
            var results: [String: Float] = [:]
            for (i, label) in labels.enumerated() {
                results[label] = probabilities[i]
            }
            predictionProbabilities = results
        } catch {
            predictionProbabilities = ["Tahmin yapılamadı": 1.0]
        }
    }

    func mapEmotionToStressLevel(emotion: String) -> String {
        switch emotion {
        case "Mutlu", "Şaşkın":
            return "Düşük"
        case "Nötr", "İğrenme":
            return "Orta"
        case "Kızgın", "Korku", "Üzgün":
            return "Yüksek"
        default:
            return "Bilinmiyor"
        }
    }

    func stressLevelColor(_ level: String) -> Color {
        switch level {
        case "Düşük":
            return .green
        case "Orta":
            return .orange
        case "Yüksek":
            return .red
        default:
            return .gray
        }
    }
    func saveToHistory(entry: HistoryEntry) {
            var existing: [HistoryEntry] = []

            if let data = UserDefaults.standard.data(forKey: "stressHistory"),
               let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
                existing = decoded
            }

            existing.append(entry)

            if let encoded = try? JSONEncoder().encode(existing) {
                UserDefaults.standard.set(encoded, forKey: "stressHistory")
            }
        }
    }

