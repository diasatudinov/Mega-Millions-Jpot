//
//  GamesView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 10.01.2025.
//

import SwiftUI

struct GamesView: View {
    @StateObject var user = User.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showGame1 = false
    @State private var showGame2 = false
    @State private var showGame3 = false
    
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
                }
                
                Spacer()
                
                HStack(spacing: 25) {
                    
                    ZStack {
                        Image(.gameBg)
                            .resizable()
                            .scaledToFit()
                            
                        VStack(spacing: 0) {
                            Spacer()
                            Image(.gameIcon1)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 120:60)
                                .padding(.bottom)
                            HStack {
                                Image(.line)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 40:20)
                                Text("1")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:20))
                                    .foregroundStyle(.yellow)
                            }.padding(.bottom, DeviceInfo.shared.deviceType == .pad ? 20:10)
                            
                            Button {
                                showGame1 = true
                            } label: {
                                TextBg(height: DeviceInfo.shared.deviceType == .pad ? 100:50, text: "PLAY", textSize: DeviceInfo.shared.deviceType == .pad ? 32:16)
                            }
                        }.padding(.vertical)
                    }.frame(height: DeviceInfo.shared.deviceType == .pad ? 450:230)
                    
                    ZStack {
                        Image(.gameBg)
                            .resizable()
                            .scaledToFit()
                            
                        VStack(spacing: 0) {
                            Spacer()
                            Image(.gameIcon2)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 180:90)
                                .padding(.bottom)
                            HStack {
                                Image(.line)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 40:20)
                                Text("1")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:20))
                                    .foregroundStyle(.yellow)
                            }.padding(.bottom, DeviceInfo.shared.deviceType == .pad ? 20:10)
                            
                            Button {
                                showGame2 = true
                            } label: {
                                TextBg(height: DeviceInfo.shared.deviceType == .pad ? 100:50, text: "PLAY", textSize: DeviceInfo.shared.deviceType == .pad ? 32:16)
                            }
                        }.padding(.vertical)
                    }.frame(height: DeviceInfo.shared.deviceType == .pad ? 450:230)
                    
                    ZStack {
                        Image(.gameBg)
                            .resizable()
                            .scaledToFit()
                            
                        VStack(spacing: 0) {
                            Spacer()
                            Image(.gameIcon3)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 160:80)
                                .padding(.bottom)
                            HStack {
                                Image(.line)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 40:20)
                                Text("2")
                                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:20))
                                    .foregroundStyle(.yellow)
                            }.padding(.bottom, DeviceInfo.shared.deviceType == .pad ? 20:10)
                            
                            Button {
                                showGame3 = true
                            } label: {
                                TextBg(height: DeviceInfo.shared.deviceType == .pad ? 100:50, text: "PLAY", textSize: DeviceInfo.shared.deviceType == .pad ? 32:16)
                            }
                        }.padding(.vertical)
                    }.frame(height: DeviceInfo.shared.deviceType == .pad ? 450:230)
                }
                
                Spacer()
            }.padding()
            
        }.background(
            Image(.appBg)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
        .fullScreenCover(isPresented: $showGame1) {
            Game21View(viewModel: viewModel, settingsVM: settingsVM)
        }
        .fullScreenCover(isPresented: $showGame2) {
            GameRouletteView(viewModel: viewModel, settingsVM: settingsVM)
        }
        .fullScreenCover(isPresented: $showGame3) {
            GameDiceView(viewModel: viewModel, settingsVM: settingsVM)
        }
    }
    
}

#Preview {
    GamesView(viewModel: AchievementsViewModel(), settingsVM: SettingsModel())
}
