//
//  AchievementsViewModel.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//


import SwiftUI

class AchievementsViewModel: ObservableObject {
    @AppStorage("AchievementOne") var achievementOne: Bool = false
    @AppStorage("AchievementTwo") var achievementTwo: Bool = false
    @AppStorage("AchievementThree") var achievementThree: Bool = false
    @AppStorage("AchievementFour") var achievementFour: Bool = false
    
    func achievementOneDone() {
        achievementOne = true
    }
    
    func achievementTwoDone() {
        achievementTwo = true
    }
    
    func achievementThreeDone() {
        achievementThree = true
    }
    
    func achievementFourDone() {
        achievementFour = true
    }
}
