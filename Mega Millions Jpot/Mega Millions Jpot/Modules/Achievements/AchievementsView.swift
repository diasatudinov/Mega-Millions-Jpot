//
//  AchievementsView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//


import SwiftUI

struct AchievementsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: AchievementsViewModel
    @State private var currentTab: Int = 0

    var body: some View {
        
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                
                ZStack {
                    
                   
                        ZStack {
                            // Горизонтальная ориентация
                            VStack(spacing: 0) {
                                Spacer()
                                Spacer()
                                HStack(spacing: 0) {
                                    ZStack {
                                        Image(.achivement1)
                                            .renderingMode(viewModel.achievementOne ? .original : .template)
                                            .resizable()
                                            .foregroundColor(.black)
                                            .scaledToFit()
                                            
                                        
                                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 400:200)
                                    
                                    ZStack {
                                        Image(.achivement2)
                                            .renderingMode(viewModel.achievementTwo ? .original : .template)
                                            .resizable()
                                            .foregroundColor(.black)
                                            .scaledToFit()
                                            
                                        
                                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 400:200)
                                    
                                    ZStack {
                                        Image(.achivement3)
                                            .renderingMode(viewModel.achievementThree ? .original : .template)
                                            .resizable()
                                            .foregroundColor(.black)
                                            .scaledToFit()
                                            
                                        
                                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 400:200)
                                    
                                    ZStack {
                                        Image(.achivement4)
                                            .renderingMode(viewModel.achievementFour ? .original : .template)
                                            .resizable()
                                            .foregroundColor(.black)
                                            .scaledToFit()
                                            
                                        
                                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 400:200)
                                }
                                Spacer()
                                
                            }
                            
                        }
                    
                }.textCase(.uppercase)
                
                VStack {
                    ZStack {
                        HStack {
                            Spacer()
                            
                            Text("Achievements")
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
                }
                
            }.background(
                Image(.appBg)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                
            )
            
        }
    }
        
        @ViewBuilder func achivementView(image: String, header: String, text: String, isOpen: Bool) -> some View {
            
            
            
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                ZStack {
                    Image(image)
                        .renderingMode(isOpen ? .original : .template)
                        .resizable()
                        .foregroundColor(.black)
                        .scaledToFit()
                        .padding(.bottom, DeviceInfo.shared.deviceType == .pad ? 0:30)
                    
                    VStack {
                        Spacer()
                    }
                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 400:250)
                
                if DeviceInfo.shared.deviceType == .pad  {
                    Spacer()
                }
            }
            
        }
}

#Preview {
    AchievementsView(viewModel: AchievementsViewModel())
}
