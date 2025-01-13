//
//  Game21View.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 10.01.2025.
//

import SwiftUI

struct Card: Hashable {
    let value: Int
    let suit: String
    let type: String
}

struct Game21View: View {
    @StateObject var user = User.shared
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AchievementsViewModel
    
    @State private var playerCards: [Card] = []
    @State private var dealerCards: [Card] = []
    @State private var playerScore: Int = 0
    @State private var dealerScore: Int = 0
    @State private var showDealerCards = false
    @State private var gameResult: String? = nil
    @State private var isGameOver = false
    
    @State private var winStrike: Int = 0
    
    let suits = ["pk", "ch", "bb", "kr"]
    let cardTypes = [
        "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"
    ]
    
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
                        }
                        .frame(height: 50)
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
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40 : 25))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 70 : 40)
                    
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
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40 : 25))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 70 : 40)
                    
                    Spacer()
                    
                    ZStack {
                        Image(.backBtn)
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(height: 50)
                    .opacity(0)
                }
                .padding(.bottom)
                
                HStack {
                    Spacer()
                    Image("cardBack")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 95)
                        .opacity(0)
                    Spacer()
                    // Dealer Section
                    VStack {
                        Text("Dealer")
                            .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 50:25))
                            .foregroundStyle(.overYellow)
                        HStack {
                            ForEach(dealerCards, id: \.self) { card in
                                CardView(card: card, hidden: !showDealerCards && dealerCards.first == card)
                            }
                        }
                        if showDealerCards {
                            Text("Очки: \(dealerScore)")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 36:18))
                                .foregroundStyle(.overYellow)
                        }
                    }
                    
                    Divider()
                    
                    // Player Section
                    VStack {
                        Text("Player")
                            .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 50:25))
                            .foregroundStyle(.overYellow)
                        HStack {
                            ForEach(playerCards, id: \.self) { card in
                                CardView(card: card)
                            }
                        }
                        if showDealerCards {
                            Text("Очки: \(playerScore)")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 36:18))
                                .foregroundStyle(.overYellow)
                        }
                    }
                    Spacer()
                    Image("cardBack")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 95)
                    Spacer()
                }
                
                
                
                HStack {
                    
                    
                    Button {
                        dealCard(toPlayer: true)
                    } label: {
                        ZStack {
                            Image(.diceBg)
                                .resizable()
                                .scaledToFit()
                            Text("More")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:20))
                                .foregroundStyle(.secondaryGold)
                        }.frame(height: 40)
                    }
                    
                    Button {
                        endPlayerTurn()
                    }  label: {
                        ZStack {
                            Image(.diceBg)
                                .resizable()
                                .scaledToFit()
                            Text("Stand")
                                .font(.custom(Fonts.regular.rawValue, size: DeviceInfo.shared.deviceType == .pad ? 40:20))
                                .foregroundStyle(.secondaryGold)
                        }.frame(height: 40)
                    }
                }
                
                //                else {
                //                    Button("Новая Игра") {
                //                        startNewGame()
                //                    }
                //                    .buttonStyle(.borderedProminent)
                //                }
                Spacer()
            }
            .padding()
            .onAppear(perform: startNewGame)
            
            if isGameOver {
                ZStack {
                    Image(.gameOverBg)
                        .resizable()
                        .scaledToFill()
                        .opacity(0.66)
                        .ignoresSafeArea()
                    
                    VStack {
                        
                        if dealerScore > 21 {
                            Text("WIN!")
                                .font(.custom(Fonts.regular.rawValue, size: 50))
                                .foregroundStyle(.overYellow)
                        } else if playerScore > dealerScore {
                            Text("WIN!")
                                .font(.custom(Fonts.regular.rawValue, size: 50))
                                .foregroundStyle(.overYellow)
                        } else if playerScore == dealerScore {
                            Text("DRAW!")
                                .font(.custom(Fonts.regular.rawValue, size: 50))
                                .foregroundStyle(.overYellow)
                        } else {
                            Text("LOSE!")
                                .font(.custom(Fonts.regular.rawValue, size: 50))
                                .foregroundStyle(.overYellow)
                        }
                        
                        
                        ZStack {
                            Image("21gameOver")
                                .resizable()
                                .scaledToFit()
                            
                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 200:100)
                        
                        
                        Button {
                            startNewGame()
                        } label: {
                            TextBg(height: 70, text: "NEXT", textSize: 20)
                        }
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            TextBg(height: 70, text: "HOME", textSize: 20)
                            
                        }
                    }
                    
                }
            }
        }
        .background(
            Image(.appBg)
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
        )
    }
    
    // MARK: - Game Logic
    func startNewGame() {
        playerCards = []
        dealerCards = []
        playerScore = 0
        dealerScore = 0
        showDealerCards = false
        gameResult = nil
        isGameOver = false
        
        // Deal initial cards
        dealCard(toPlayer: true)
        dealCard(toPlayer: true)
        dealCard(toPlayer: false)
        dealCard(toPlayer: false)
    }
    
    func dealCard(toPlayer: Bool) {
        let card = drawCard()
        if toPlayer {
            playerCards.append(card)
            playerScore = calculateScore(for: playerCards)
            
            if playerScore > 21 {
                gameResult = "Перебор! Вы проиграли."
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isGameOver = true
                }
            }
        } else {
            dealerCards.append(card)
            dealerScore = calculateScore(for: dealerCards)
        }
    }
    
    func endPlayerTurn() {
        showDealerCards = true
        
        // Dealer's turn: dealer must draw until their score is 17 or more
        while dealerScore < 17 {
            dealCard(toPlayer: false)
        }
        
        // Determine the result
        if dealerScore > 21 {
            winStrike += 1
        } else if playerScore > dealerScore {
            winStrike += 1
        } else if playerScore == dealerScore {
            winStrike = 0
        } else {
            winStrike = 0
        }
        
        if winStrike > 5 {
            viewModel.achievementThreeDone()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isGameOver = true
        }
    }
    
    func drawCard() -> Card {
        let randomSuit = suits.randomElement()! // Случайная масть
        let randomType = cardTypes.randomElement()! // Случайный тип карты
        
        // Определяем значение карты в зависимости от типа
        let value: Int
        switch randomType {
        case "Jack", "Queen", "King":
            value = 10 // Валет, Дама, Король — по 10 очков
        case "Ace":
            value = 11 // Туз — 11 очков
        default:
            value = Int(randomType)! // Остальные карты — их числовое значение
        }
        
        return Card(value: value, suit: randomSuit, type: randomType)
    }
    
    func calculateScore(for cards: [Card]) -> Int {
        var total = cards.map { $0.value }.reduce(0, +)
        var aceCount = cards.filter { $0.value == 11 }.count
        
        // Adjust for Aces if total exceeds 21
        while total > 21 && aceCount > 0 {
            total -= 10
            aceCount -= 1
        }
        
        return total
    }
}

struct CardView: View {
    let card: Card
    var hidden: Bool = false
    
    var body: some View {
        if hidden {
            Image("cardBack")
                .resizable()
                .scaledToFit()
                .frame(height: 95)
        } else {
            Image("\(card.suit)_\(card.type)")
                .resizable()
                .scaledToFit()
                .frame(height: 95)
        }
    }
}

#Preview {
    Game21View(viewModel: AchievementsViewModel())
}
