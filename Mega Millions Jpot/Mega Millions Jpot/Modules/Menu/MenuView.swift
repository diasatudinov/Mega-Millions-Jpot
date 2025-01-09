//
//  MenuView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//


import SwiftUI

struct MenuView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showTraining = false
    @State private var showGame = false
    @State private var showResults = false
    @State private var showRules = false
    @State private var showSettings = false
    
    @State private var timeRemaining: String = "24:00"
    @State private var timerActive: Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
//    @StateObject var settingsVM = SettingsModel()
    @StateObject var teamVM = TeamViewModel()
    
    var body: some View {
        if teamVM.currentTeam != nil {
            TeamsView(viewModel: teamVM)
        } else {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                    
                    if geometry.size.width < geometry.size.height {
                        // Вертикальная ориентация
                        ZStack {
                            
                            
                            
                            HStack {
                                Spacer()
                                VStack(spacing: 25) {
                                   
                                
                                    Button {
                                        showTraining = true
                                    } label: {
                                        TextBg(height: DeviceInfo.shared.deviceType == .pad ? 140 : 86, text: "Games", textSize: DeviceInfo.shared.deviceType == .pad ? 40 : 22)
                                    }
                                    
                                    
                                    Button {
                                        
                                        showGame = true
                                    } label: {
                                        TextBg(height: DeviceInfo.shared.deviceType == .pad ? 140 : 86, text: "Achievements", textSize: DeviceInfo.shared.deviceType == .pad ? 32 : 20)
                                    }
                                    
                                    Button {
                                        showSettings = true
                                    } label: {
                                        TextBg(height: DeviceInfo.shared.deviceType == .pad ? 140 : 86, text: "Settings", textSize: DeviceInfo.shared.deviceType == .pad ? 40 : 22)
                                    }
                                    
                                    
                                    DailyRouletteBoard(height: 200, btnText: "SPIN", btnPress: {})
                                    
                                    
                                }
                                Spacer()
                            }
                            
                            
                            
                        }
                    } else {
                        ZStack {
                            
                            VStack {
                                Spacer()
                                
                                VStack(spacing: 15) {
                                    
                                    HStack(spacing: 15) {
                                        Spacer()
                                        Button {
                                            showTraining = true
                                        } label: {
                                            TextBg(height: DeviceInfo.shared.deviceType == .pad ? 90 : 46, text: "Training", textSize: DeviceInfo.shared.deviceType == .pad ? 40 : 24)
                                        }
                                        
                                        
                                        Button {
                                            
                                            showGame = true
                                        } label: {
                                            TextBg(height: DeviceInfo.shared.deviceType == .pad ? 90 : 46, text: "Online", textSize: DeviceInfo.shared.deviceType == .pad ? 40 : 24)
                                        }
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 15) {
                                        Spacer()
                                        Button {
                                            withAnimation {
                                                showResults = true
                                            }
                                        } label: {
                                            TextBg(height: DeviceInfo.shared.deviceType == .pad ? 90 : 46, text: "Best Results", textSize: DeviceInfo.shared.deviceType == .pad ? 40 : 24)
                                        }
                                        
                                        Button {
                                            showRules = true
                                        } label: {
                                            TextBg(height: DeviceInfo.shared.deviceType == .pad ? 90 : 46, text: "Rules", textSize: DeviceInfo.shared.deviceType == .pad ? 40 : 24)
                                        }
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 5) {
                                        Spacer()
                                        
                                        
                                        Button {
                                            showSettings = true
                                        } label: {
                                            TextBg(height: DeviceInfo.shared.deviceType == .pad ? 90 : 46, text: "Settings", textSize: DeviceInfo.shared.deviceType == .pad ? 40 : 24)
                                        }
                                        Spacer()
                                    }
                                    
                                    
                                }
                                Spacer()
                            }
                            
                            
                        }
                    }
                    Spacer()
                }
                .background(
                    Image(.appBg)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                    
                )
                .onAppear {
                    updateTimer()
                }
                .onReceive(timer) { _ in
                    updateTimer()
                }
//                .onAppear {
//                    if settingsVM.musicEnabled {
//                        MusicPlayer.shared.playBackgroundMusic()
//                    }
//                }
//                .onChange(of: settingsVM.musicEnabled) { enabled in
//                    if enabled {
//                        MusicPlayer.shared.playBackgroundMusic()
//                    } else {
//                        MusicPlayer.shared.stopBackgroundMusic()
//                    }
//                }
                .fullScreenCover(isPresented: $showTraining) {
                 //   TrainingView(viewModel: trainingVM, settingsVM: settingsVM)
                }
                .fullScreenCover(isPresented: $showGame) {
                 //   OnlineView(teamVM: teamVM, settingsVM: settingsVM)
                }
                .fullScreenCover(isPresented: $showRules) {
                    //RulesView()
                }
                .fullScreenCover(isPresented: $showSettings) {
                   // SettingsView(settings: settingsVM, teamVM: teamVM)
                    
                }
                
            }
        }
        
    }
    
    private func updateTimer() {
        guard let lastPressDate = UserDefaults.standard.object(forKey: "LastPressDate") as? Date else {
            timeRemaining = "00:00" // If no saved date, assume timer is full
            timerActive = false
            return
        }
        
        let now = Date()
        let totalDuration: TimeInterval = 24 * 60 * 60 // 24 hours in seconds
        let elapsedTime = now.timeIntervalSince(lastPressDate) // Time since lastPressDate
        let remainingTime = totalDuration - elapsedTime // Time left
        
        if remainingTime <= 0 {
            timeRemaining = "00:00"
            timerActive = false
        } else {
            timerActive = true
            let hours = Int(remainingTime) / 3600
            let minutes = (Int(remainingTime) % 3600) / 60
            timeRemaining = String(format: "%02d:%02d", hours, minutes) // Format as hh:mm
        }
    }
    
//    private func handleButtonPress(point: Int) {
//        user.updateUserCoins(for: point)
//        lastPressDate = Date() // Update last press date
//        UserDefaults.standard.set(lastPressDate, forKey: "LastPressDate")
//        UserDefaults.standard.set(boxStates, forKey: "boxStates")
//        UserDefaults.standard.set(savedBonus, forKey: "savedBonus")
//        
//        isButtonDisabled = true // Disable button
//        
//        // Optionally refresh button state after 24 hours
//        DispatchQueue.main.asyncAfter(deadline: .now() + 24 * 60 * 60) {
//            checkButtonState()
//        }
//    }
    
}

#Preview {
    MenuView()
}
