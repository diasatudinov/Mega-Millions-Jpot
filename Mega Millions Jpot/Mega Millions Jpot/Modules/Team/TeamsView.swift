//
//  TeamsView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//


import SwiftUI

struct TeamsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TeamViewModel
    @State private var currentTab: Int = 0
    var body: some View {
        ZStack {

           
            
            HStack {
                
                
                
                TabView(selection: $currentTab) {
                    ForEach(viewModel.teams.indices, id: \.self) { index in
                        achivementView(image: viewModel.teams[index].icon, header: viewModel.teams[index].name, imageHeight: 204, team: viewModel.teams[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                
                .frame(width: DeviceInfo.shared.deviceType == .pad ? 480 : 240)
                
            }
        }
    }
    
    @ViewBuilder func achivementView(image: String, header: String, imageHeight: CGFloat, team: Team) -> some View {
        
        
        HStack(spacing: 20) {
            
            VStack(alignment: .center, spacing: 10) {
                
                Image(image)
                    .resizable()
                    .foregroundColor(.black)
                    .scaledToFit()
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? imageHeight * 1.8 : imageHeight)
                
                
                Text(header)
                    .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 48:24))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .textCase(.uppercase)
                    .padding(.bottom, 8)
                
                
                Button {
                    
                    viewModel.currentTeam = team
                } label: {
                    TextBg(height: DeviceInfo.shared.deviceType == .pad ? 90:46, text: viewModel.currentTeam?.name == header ? "Selected" : "Select", textSize: DeviceInfo.shared.deviceType == .pad ? 48:24)
                    
                }
                
                
            }
            
        }
    }
}

#Preview {
    TeamsView(viewModel: TeamViewModel())
}
