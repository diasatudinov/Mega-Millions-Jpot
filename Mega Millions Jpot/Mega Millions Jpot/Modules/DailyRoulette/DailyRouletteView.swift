//
//  DailyRouletteView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 10.01.2025.
//

import SwiftUI

struct DailyRouletteView: View {
    @StateObject var user = User.shared
    @State private var bonusPoints: Int? = nil // To display the bonus points after button press
    @State private var lastPressDate: Date? = nil // Track the last press date
    @State private var isButtonDisabled: Bool = false // Disable button logic
    @Environment(\.presentationMode) var presentationMode
    
    @State private var rotationAngle: Double = 0
    @State private var isSpinning = false
    @State private var reward: Int? = nil

    let rewards = [0, 10, 20, 30, 40, 50, 100]
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        handleButtonPress()
                    } label: {
                        TextBg(height: 70, text: "START", textSize: 16)
                            .opacity(isButtonDisabled ? 0.5 : 1.0)
                    } .disabled(isButtonDisabled)
                    Spacer()
                    VStack {
                        Spacer()
                        ZStack {
                            
                            Image("spinner")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.degrees(rotationAngle))
                            
                            VStack {
                                Image(.spinnerTriangle)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                Spacer()
                            }
                        }.frame(width: 300, height: 350)
                        
                    }
                    Spacer()
                    TextBg(height: 70, text: "START", textSize: 16)
                        .opacity(0)
                }
                
            }
            VStack {
                ZStack {
                    HStack {
                        Spacer()
                        
                        Text("Daily roulette")
                            .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 60:35))
                            .foregroundStyle(.yellow)
                            .textCase(.uppercase)
                            
                        
                        Spacer()
                    }
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
                    }.padding()
                }
                Spacer()
                if let reward = reward {
                    Text("You won \(reward) coins!")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
        }.background(
            Image(.appBg)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
        .onAppear {
            checkButtonState()
        }
        
    }
    
    func startSpinning() {
        reward = nil // Reset reward
        isSpinning = true

        // Spin the spinner for 3 seconds
        withAnimation(.easeInOut(duration: 3)) {
            let spins = Double.random(in: 3...5)
            rotationAngle += spins * 360
        }

        // Determine the reward after the spin
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            reward = rewards.randomElement() // Pick a random reward
            if let reward = reward {
                user.updateUserCoins(for: reward)
            }
            isSpinning = false
            isButtonDisabled = false
        }
    }
    
    private func handleButtonPress() {
        startSpinning()
        lastPressDate = Date() // Update last press date
        UserDefaults.standard.set(lastPressDate, forKey: "LastPressDate")
        UserDefaults.standard.set(reward, forKey: "savedBonus")
        
        isButtonDisabled = true // Disable button
        
//        // Optionally refresh button state after 24 hours
        DispatchQueue.main.asyncAfter(deadline: .now() + 24 * 60 * 60) {
            checkButtonState()
        }
    }
    
    private func checkButtonState() {
       
        if let savedDate = UserDefaults.standard.object(forKey: "LastPressDate") as? Date {
            let elapsedTime = Date().timeIntervalSince(savedDate)
            if elapsedTime >= 24 * 60 * 60 {
                isButtonDisabled = false // Re-enable button
            } else {
                isButtonDisabled = true
            }
        }
        
        
    }
}

#Preview {
    DailyRouletteView()
}
