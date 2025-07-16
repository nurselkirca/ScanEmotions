//
//  HomeView.swift
//  ScanEmotion
//
//  Created by Nursel Kırca on 15.06.2025.
//
import SwiftUI

struct HomeView: View {
    @State private var showStressMeasurement = false
    @State private var showJournal = false
    @State private var showHistory = false
    @State private var showBreathing = false
    @State private var showSuggestions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Stres Analizi")
                    .font(.largeTitle)
                    .bold()
                NavigationLink(destination: JournalView(), isActive: $showJournal) { EmptyView() }
                NavigationLink(destination: StressMeasurementView(), isActive: $showStressMeasurement) { EmptyView() }
                NavigationLink(destination: HistoryView(), isActive: $showHistory) { EmptyView() }
                NavigationLink(destination: BreathingExerciseView(), isActive: $showBreathing) { EmptyView() }
                NavigationLink(destination: SuggestionsView(predictionProbabilities: [:]), isActive: $showSuggestions) { EmptyView() }
                
                // Stres Ölçümü
                Button("Stres Ölçümü Yap") {
                    showStressMeasurement = true
                }
                .modifier(MainButtonStyle(color: .blue))
                
                // Veri Geçmişi
                Button("Veri Geçmişi") {
                    showHistory = true
                }
                .modifier(MainButtonStyle(color: .purple))
                
                // Nefes Egzersizleri
                Button("Nefes Egzersizleri") {
                    showBreathing = true
                }
                .modifier(MainButtonStyle(color: .teal))
                
                Button("Günlük Tut") {
                    showJournal = true
                }
                .modifier(MainButtonStyle(color: .green))
                Spacer()
            }
            .padding()
            .navigationTitle("")
        }
    }
}

// ✅ Ortak Buton Görünümü
struct MainButtonStyle: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}
