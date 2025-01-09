//
//  SplashScreen.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 09.01.2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var scale: CGFloat = 1.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?
    
    @State private var cardOffsets: [CGFloat] = Array(repeating: 0, count: 6)
    @State private var currentCardIndex = 0
    var body: some View {
        ZStack {
    
            VStack(spacing: 0) {
                Spacer()
                
                
                HStack {
                    // Grayscale image
                    ForEach(0..<6) { card in
                        Image(.splashCard)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 250:160)
                            .padding(.leading, DeviceInfo.shared.deviceType == .pad ? -120:-80)
                            .opacity(1) // Adjust opacity if needed
                            .offset(y: cardOffsets[card])
                            
                    }
                }
                .offset(x: 30).padding(.bottom, -16)
                VStack {
                    Text("loading...")
                        .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 50:30))
                        .foregroundStyle(.gold)
                 
                    
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .accentColor(Color.gold)
                        .cornerRadius(10)
                        .padding(.horizontal, 1)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.secondaryGold)
                        }
                        .scaleEffect(y: 4.0, anchor: .center)
                        .padding(.horizontal, 192)
                }
                
                
            }.padding(.bottom, 30)
        }.background(
            Image(.appBg)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
        )
        .onAppear {
            startTimer()
            startCardAnimation()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 100 {
                progress += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    
    func startCardAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.5)) {
                cardOffsets[currentCardIndex] = -80 // Adjust the offset value as needed
            }
            currentCardIndex += 1

            if currentCardIndex == cardOffsets.count {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
