
import SwiftUI
import CoreML
import UIKit

struct ContentView: View {
    @State private var image: UIImage?
    @State private var predictionText: String = ""
    @State private var showImagePicker = false
    @State private var useCamera = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }
            
            HStack {
                Button("Galeri") {
                    useCamera = false
                    showImagePicker = true
                }
                
                Button("Kamera") {
                    useCamera = true
                    showImagePicker = true
                }
            }
            
            Text(predictionText)
                .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: useCamera ? .camera : .photoLibrary,
                        image: $image,
                        onImagePicked: classifyImage)
        }
    }
    
    
    func classifyImage(_ uiImage: UIImage) {
        guard let inputArray = imageToMultiArray(image: uiImage) else {
            predictionText = "Görüntü dönüştürülemedi."
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
            
            let labels = ["Angry", "Disgust", "Fear", "Happy", "Sad", "Surprise", "Neutral"]
            let result = zip(labels, probabilities).map { "\($0): \(String(format: "%.2f", $1 * 100))%" }.joined(separator: "\n")
            predictionText = result
        } catch {
            predictionText = "Tahmin yapılamadı: \(error.localizedDescription)"
        }
    }
}
