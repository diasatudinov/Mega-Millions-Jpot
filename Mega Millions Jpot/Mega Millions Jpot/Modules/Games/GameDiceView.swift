//
//  GameDiceView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 10.01.2025.
//

import SwiftUI
import AVFoundation


struct DiceView: View {
    let value: Int

    var body: some View {
        Image("dice\(value)")
            .resizable()
            .scaledToFit()
            .frame(height: DeviceInfo.shared.deviceType == .pad ? 160:85)
            .shadow(radius: 5)
    }
}


struct GameDiceView: View {
    @StateObject var user = User.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var playerDice: [Int] = [1, 1]
    @State private var dealerDice: [Int] = [1, 1]
    @State private var playerScore: Int = 0
    @State private var dealerScore: Int = 0
    @State private var gameResult: String? = nil
    @State private var isGameOver = false
    @State private var isRolling = false
    @State private var winStrike: Int = 0
    @State private var audioPlayer: AVAudioPlayer?

    @ObservedObject var viewModel: AchievementsViewModel
    @ObservedObject var settingsVM: SettingsModel
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Image(.backBtn)
                                .resizable()
                                .scaledToFit()
                            
                        }.frame(height: 50)
                        
                    }
                    
                    Spacer()
                    ZStack {
                        Image(.moneyBg)
                            .resizable()
                            .scaledToFit()
                        HStack {
                            Image(.coin)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 5)
                            Text("\(user.coins)")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:25))
                                .foregroundStyle(.white)
                        }
                    }.frame(height: DeviceInfo.shared.deviceType == .pad ? 70:35)
                    
                    ZStack {
                        Image(.moneyBg)
                            .resizable()
                            .scaledToFit()
                        HStack {
                            Image(.line)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 5)
                            Text("\(user.energy)")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:25))
                                .foregroundStyle(.white)
                        }
                    }.frame(height: DeviceInfo.shared.deviceType == .pad ? 70:35)
                    
                    Spacer()
                    
                    ZStack {
                        Image(.backBtn)
                            .resizable()
                            .scaledToFit()
                        
                    }.frame(height: 50).opacity(0)
                }.padding(.bottom)

                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        VStack(spacing: 30) {
                            ZStack {
                                Image(.diceBg)
                                    .resizable()
                                    .scaledToFit()
                                Text("\(playerScore)")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 80:40))
                                    .foregroundStyle(.secondaryGold)
                                
                            }.frame(height: DeviceInfo.shared.deviceType == .pad ? 130:75)
                            
                            HStack(spacing: DeviceInfo.shared.deviceType == .pad ? 100:50) {
                                ForEach(playerDice, id: \.self) { die in
                                    DiceView(value: die)
                                }
                            }
                        }
                        
                        
                        Text("Player")
                            .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 50:25))
                            .foregroundStyle(.overYellow)
                    }
                    
                    Spacer()
                    
                    VStack {
                        VStack(spacing: 30) {
                            ZStack {
                                Image(.diceBg)
                                    .resizable()
                                    .scaledToFit()
                                Text("\(dealerScore)")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 80:40))
                                    .foregroundStyle(.secondaryGold)
                                
                            }.frame(height: DeviceInfo.shared.deviceType == .pad ? 130:75)
                            
                            HStack(spacing: DeviceInfo.shared.deviceType == .pad ? 100:50) {
                                ForEach(dealerDice, id: \.self) { die in
                                    DiceView(value: die)
                                }
                            }
                        }
                        
                        
                        Text("Dealer")
                            .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 50:25))
                            .foregroundStyle(.overYellow)
                    }
                    
                    Spacer()
                    
                }
                
                if !isGameOver {
                    Spacer()
                    Button {
                        playSound(named: "takeStar")
                        rollDice()
                    } label: {
                        TextBg(height: DeviceInfo.shared.deviceType == .pad ? 100:50, text: "Start", textSize: DeviceInfo.shared.deviceType == .pad ? 40:20)
                    }
                    .disabled(isRolling)
                }
                Spacer()
            }.padding()
            
            if isGameOver {
                ZStack {
                    Image(.gameOverBg)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.66)
                    .ignoresSafeArea()
                    
                    VStack {
                        if playerScore > dealerScore {
                            Text("WIN!")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 100:50))
                                .foregroundStyle(.overYellow)
                        } else if playerScore < dealerScore {
                            Text("LOSE!")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 100:50))
                                .foregroundStyle(.overYellow)
                            
                        } else {
                            Text("DRAW!")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 100:50))
                                .foregroundStyle(.overYellow)
                        }
                        
                        if playerScore > dealerScore {
                            ZStack {
                                Image(.moneyBg)
                                    .resizable()
                                    .scaledToFit()
                                HStack {
                                    Image(.coin)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.vertical, 5)
                                    Text("+100")
                                        .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:25))
                                        .foregroundStyle(.white)
                                }
                            }.frame(height: DeviceInfo.shared.deviceType == .pad ? 70:40)
                        }
                        
                        Button {
                            startNewGame()
                        } label: {
                            TextBg(height: DeviceInfo.shared.deviceType == .pad ? 140:70, text: "NEXT", textSize: DeviceInfo.shared.deviceType == .pad ? 40:20)
                            
                        }
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            TextBg(height: DeviceInfo.shared.deviceType == .pad ? 140:70, text: "HOME", textSize: DeviceInfo.shared.deviceType == .pad ? 40:20)
                            
                        }
                    }
                    
                }
            }
            
            
        }.background(
            Image(.appBg)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
        
    }
    
    // MARK: - Game Logic
    func startNewGame() {
        playerDice = [1, 1]
        dealerDice = [1, 1]
        playerScore = 0
        dealerScore = 0
        gameResult = nil
        isGameOver = false
        isRolling = false
    }

    func rollDice() {
        isRolling = true
        gameResult = nil

        var iterations = 0
        let maxIterations = 20 // Adjust for 2 seconds (10 changes per second)

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            iterations += 1

            // Randomly change dice values during rolling
            playerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]
            dealerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]

            if iterations >= maxIterations {
                timer.invalidate() // Stop the timer after 2 seconds

                // Finalize dice values
                playerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]
                dealerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]
                playerScore = playerDice.reduce(0, +)
                dealerScore = dealerDice.reduce(0, +)

                if playerScore > dealerScore {
                    user.updateUserXP()
                    user.updateUserCoins(for: 100)
                    
                    winStrike += 1
                } else if playerScore < dealerScore {
                    user.minusUserEnergy(for: 2)
                    winStrike = 0
                } else {
                    winStrike = 0
                }
                
                if winStrike > 5 {
                    viewModel.achievementTwoDone()
                }
                isGameOver = true
                isRolling = false
            }
        }
    }
    
    func playSound(named soundName: String) {
        if settingsVM.soundEnabled {
            if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                } catch {
                    print("Error playing sound: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    GameDiceView(viewModel: AchievementsViewModel(), settingsVM: SettingsModel())
}
