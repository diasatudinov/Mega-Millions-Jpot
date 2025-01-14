//
//  GameRouletteView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 10.01.2025.
//

import SwiftUI
import AVFoundation

struct GameRouletteView: View {
    @StateObject var user = User.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedColor: String? = nil
    @State private var resultColor: String = ""
    @State private var isSpinning: Bool = false
    @State private var rotationAngle: Double = 0
    
    @State private var gameOver: Bool = false
    @State private var winStrike: Int = 0
    
    
    let colors = ["White", "Green", "Red"]
    let colorMultipliers = ["Red": 2, "White": 2, "Green": 10]
    
    @ObservedObject var viewModel: AchievementsViewModel
    @ObservedObject var settingsVM: SettingsModel
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        GeometryReader { geometry in
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
                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 70:40)
                        
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
                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 70:40)
                        
                        Spacer()
                        
                        ZStack {
                            Image(.backBtn)
                                .resizable()
                                .scaledToFit()
                            
                        }.frame(height: 50).opacity(0)
                    }.padding(.bottom)
                    
                    HStack {
                        
                        VStack(spacing: DeviceInfo.shared.deviceType == .pad ? 60:30) {
                            ZStack {
                                
                                Image(.colorsBg)
                                    .resizable()
                                    .scaledToFit()
                                VStack(spacing: DeviceInfo.shared.deviceType == .pad ? 40:20) {
                                    ForEach(colors, id: \.self) { color in
                                        Button(action: {
                                            selectedColor = color
                                        }) {
                                            HStack {
                                                Text(color)
                                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:20))
                                                    .cornerRadius(10)
                                                    .foregroundColor(.secondaryGold)
                                                Spacer()
                                                Image(selectedColor == color ? .colorOn : .colorOff)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 50:25)
                                            }.frame(width: DeviceInfo.shared.deviceType == .pad ? 300:150)
                                        }
                                    }
                                }
                            }.frame(height: DeviceInfo.shared.deviceType == .pad ? 300:150)
                            
                            Button {
                                playSound(named: "takeStar")
                                spinRoulette()
                            }label:{
                                TextBg(height: DeviceInfo.shared.deviceType == .pad ? 140:70, text: "START", textSize: DeviceInfo.shared.deviceType == .pad ? 32:16)
                                    .opacity(selectedColor != nil ? 1 : 0.5)
                                
                            }
                            .disabled(selectedColor == nil)
                            
                        }
                        Spacer()
                        
                        VStack {
                            ZStack {
                                Image(.rouletteWheel)
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: rotationAngle))
                                    .animation(isSpinning ? .easeInOut(duration: 2) : .default, value: rotationAngle)
                                
                                
                            }.frame(width: DeviceInfo.shared.deviceType == .pad ? 400:200, height: DeviceInfo.shared.deviceType == .pad ? 480:240)
                        }
                        Spacer()
                        ZStack {
                            
                            Image(.colorsBg)
                                .resizable()
                                .scaledToFit()
                            VStack(spacing: DeviceInfo.shared.deviceType == .pad ? 40:20) {
                                HStack {
                                    Text("red")
                                        .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:20))
                                        .cornerRadius(10)
                                        .foregroundColor(.secondaryGold)
                                    Spacer()
                                    Image(selectedColor == "red" ? .colorOn : .colorOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 50:25)
                                }.frame(width: DeviceInfo.shared.deviceType == .pad ? 300:150)
                                
                                
                            }
                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 300:150).opacity(0)
                    }
                    
                    Spacer()
                }.padding()
                
                if gameOver {
                    ZStack {
                        Image(.gameOverBg)
                            .resizable()
                            .scaledToFill()
                            .opacity(0.66)
                            .ignoresSafeArea()
                        
                        VStack {
                            Text(resultColor == selectedColor ? "WIN!" : "LOSE!")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 100:50))
                                .foregroundStyle(.overYellow)
                            if let mult = colorMultipliers[resultColor], resultColor == selectedColor {
                                Text("X\(mult)")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 100:50))
                                    .foregroundStyle(.overYellow)
                            }
                            
                            if resultColor == selectedColor {
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
                                gameOver = false
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
    }
    
    private func spinRoulette() {
        guard let selectedColor = selectedColor else { return }
        isSpinning = true
        resultColor = ""
        
        // Начать вращение
        let randomSpin = Double.random(in: 1440...2880)
        rotationAngle += randomSpin
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSpinning = false
            // Определить результат
            let randomColor = colors[Int.random(in: 0..<colors.count)]
            resultColor = randomColor
            
            if resultColor == selectedColor {
                user.updateUserXP()
                user.updateUserCoins(for: 100)
                winStrike += 1
            } else {
                user.minusUserEnergy(for: 1)
                winStrike = 0
            }
            
            if winStrike > 5 {
                viewModel.achievementFourDone()
            }
            
            gameOver = true
            
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
    GameRouletteView(viewModel: AchievementsViewModel(), settingsVM: SettingsModel())
}
