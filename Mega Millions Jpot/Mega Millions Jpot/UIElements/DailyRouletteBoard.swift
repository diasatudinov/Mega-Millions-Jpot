//
//  DailyRouletteBoard.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//

import SwiftUI

struct DailyRouletteBoard: View {
    var height: CGFloat
    var btnText: String
    var btnPress: () -> ()
    var body: some View {
        ZStack {
            
            Image(.dailyRouletteBg)
                .resizable()
                .scaledToFit()
            
            VStack {
                Text("Daily Roulette")
                    .font(.custom(Fonts.regular.rawValue, size: 14))
                    .foregroundStyle(.secondaryGold)
                
                Image(.dailySpin)
                    .resizable()
                    .scaledToFit()
                
                Button {
                    btnPress()
                } label: {
                    TextBg(height: 45, text: btnText, textSize: 16)
                }
            }.padding(.vertical)
        }.frame(height: height)
    }
}

#Preview {
    DailyRouletteBoard(height: 200, btnText: "SPIN", btnPress: {})
}
