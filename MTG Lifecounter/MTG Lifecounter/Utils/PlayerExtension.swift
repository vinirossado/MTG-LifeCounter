//
//  PlayerExtension.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 12.03.2025.
//

import Foundation
extension PlayerState {
    /// Obtém os estados iniciais de vida de todos os jogadores
    /// - Returns: Um dicionário com o ID do jogador como chave e sua vida inicial como valor
    func getInitialPlayerLives() -> [UUID: Int] {
        var initialLives: [UUID: Int] = [:]
        
        for player in players {
            initialLives[player.id] = player.HP
        }
        
        return initialLives
    }
    
    /// Obtém os estados iniciais de vida de todos os jogadores em formato de array
    /// - Returns: Um array com os valores de vida inicial de cada jogador, na ordem em que estão armazenados
    func getInitialPlayerLivesArray() -> [Int] {
        return players.map { $0.HP }
    }
    
    /// Reinicia todos os jogadores para seus valores de vida inicial
    func resetAllPlayersToInitialLife() {
        for index in 0..<players.count {
            players[index].HP = players[index].HP
        }
    }
}
