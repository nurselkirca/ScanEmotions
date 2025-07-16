//
//  LoginView.swift
//  ScanEmotion
//
//  Created by Nursel Kırca on 15.06.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            MainTabView()
        } else {
            VStack(spacing: 20) {
                Text("Giriş Yap")
                    .font(.largeTitle)
                    .bold()

                TextField("E-posta", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Şifre", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Giriş Yap") {
                    if email.lowercased().contains("gmail") && !email.isEmpty {
                        // Email içinde "gmail" var ve boş değilse giriş başarılı
                        isLoggedIn = true
                    } else {
                        showAlert = true
                    }
                }

                NavigationLink("Kayıt Ol", destination: RegisterView())
                    .disabled(false)  // Her zaman aktif

            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Hata"), message: Text("E-posta 'gmail' içermeli"), dismissButton: .default(Text("Tamam")))
            }
        }
    }
}
