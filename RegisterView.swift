//
//  RegisterView.swift
//  ScanEmotion
//
//  Created by Nursel Kırca on 15.06.2025.
//
import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var registrationSuccess = false
    @Environment(\.presentationMode) var presentationMode  // Ekranı kapatmak için

    var body: some View {
        VStack(spacing: 20) {
            Text("Kayıt Ol")
                .font(.largeTitle)
                .bold()

            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Kayıt Ol") {
                if email.lowercased().contains("gmail") && !password.isEmpty {
                    // Basit kayıt başarılı koşulu
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(password, forKey: "password")
                    registrationSuccess = true
                } else {
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Hata"),
                      message: Text("Email 'gmail' içermeli ve şifre boş olmamalı"),
                      dismissButton: .default(Text("Tamam")))
            }
            .alert(isPresented: $registrationSuccess) {
                Alert(title: Text("Başarılı"),
                      message: Text("Kayıt başarılı! Giriş yapabilirsiniz."),
                      dismissButton: .default(Text("Tamam")) {
                          // Kayıt başarılı mesajı sonrası kayıt ekranını kapat
                          presentationMode.wrappedValue.dismiss()
                      })
            }

        }
        .padding()
    }
}

