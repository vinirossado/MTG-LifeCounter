//
//  SettingsView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 19/11/24.
//

import SwiftUI

struct SettingsView: View {
    let items: [AnyView] = Array(
            repeating: AnyView(
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 300, height: 200)
                    .foregroundStyle(.red)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 4)
                    )
                    
            ), count: 6
        )
    
    var body: some View {
        VStack() {
            Text("Settings")
                .font(.system(size: 32))
            
            Text("Players")
                .padding(.top, 32)
            
            LazyVGrid(
                columns: [
                    GridItem(.fixed(300), spacing: 16),
                    GridItem(.fixed(300), spacing: 16),
                    GridItem(.fixed(300), spacing: 16)
                ],
                spacing: 16 // Vertical spacing
            ) {
                ForEach(0..<items.count, id: \.self) { index in
                    items[index]
                }
            }
            .padding(16)
        }
        .font(.system(size: 24))
        .foregroundStyle(.white)
        .frame(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height,
            alignment: .top
        )
        .background(Color(hex: "#18181b"))
        .cornerRadius(16)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 32)
    }
}

#Preview {
    HStack() {
        SettingsView()
    }
    .scrollTargetLayout()
}

