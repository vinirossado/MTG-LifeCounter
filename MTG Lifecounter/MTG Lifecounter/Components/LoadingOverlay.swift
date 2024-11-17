//
//  LoadingOverlay.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 15.11.2024.
//

import SwiftUI

struct LoadingOverlay: View {
    
    @Binding var isShowing: Bool // Controle de visibilidade
    let message: String? // Mensagem opcional

    var body: some View {
        ZStack {
            if isShowing {
                // Fundo escurecido com efeito de Blur
                Color.darkNavyBackground
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VisualEffectBlur(blurStyle: .systemMaterialDark)
                            .edgesIgnoringSafeArea(.all)
                    )
                
                // Loading Animation e Mensagem
                VStack(spacing: 20) {
                    LoadingAnimation(colors: [.white, .blue, .green], size: 100, speed: 0.6, circleCount: 4)
                    if let message = message {
                        Text(message)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .transition(.opacity) // Suaviza a aparição/desaparecimento
            }
        }
        .animation(.easeInOut, value: isShowing)
    }
}

// Adicionando o overlay como extensão reutilizável (.loadingOverlay() dentro de qualquer stack.)
extension View {
    func loadingOverlay(isShowing: Binding<Bool>, message: String? = nil) -> some View {
        self.overlay(
            LoadingOverlay(isShowing: isShowing, message: message)
        )
    }
}

// Add suport ao Blur
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
