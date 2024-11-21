//
//  LifePointsView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//


import SwiftUI

struct LifePointsView: View {
    @EnvironmentObject var gameSettings: GameSettings
    let lifePointsOptions = [20, 25, 40, 0]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Life Points")
                .font(.system(size: 24, weight: .semibold))
                .padding(.bottom, 16)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(lifePointsOptions, id: \.self) { points in
                    Button(action: {
                        gameSettings.startingLife = points
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            gameSettings.startingLife == points ? Color.white : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                                .animation(.easeInOut(duration: 0.15), value: gameSettings.startingLife)

                            Text("\(points)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(height: 100)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    LifePointsView()
        .environmentObject(GameSettings())
}
