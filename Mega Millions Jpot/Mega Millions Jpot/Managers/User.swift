//
//  User.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//


import SwiftUI

class User: ObservableObject {
    static let shared = User()
    
    @AppStorage("coins") var storedCoins: Int = 100
    @Published var coins: Int = 100
    
    @AppStorage("experience") var storedXP: Int = 0
    @Published var xp: Int = 0
    
    @AppStorage("game2Level") var storedLevelGame: Int = 1
    @Published var levelGame: Int = 1
    
    init() {
        coins = storedCoins
        xp = storedXP
        levelGame = storedLevelGame
    }
    
    func updateUserCoins(for coins: Int) {
        self.coins += coins
        storedCoins = self.coins
    }
    
    func minusUserCoins(for coins: Int) {
        self.coins -= coins
        storedCoins = self.coins
    }
    
    func updateUserXP() {
        self.xp += 2
        
        if self.xp > 99 {
            self.xp = 0
        }
        storedXP = self.xp
    }
    
    func updateUserLevelGame2() {
        self.levelGame += 1
        storedLevelGame = self.levelGame
    }
}
