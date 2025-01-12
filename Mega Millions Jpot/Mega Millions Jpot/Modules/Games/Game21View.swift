//
//  Game21View.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 10.01.2025.
//

import SwiftUI

struct Game21View: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Game21View()
}

struct BlackjackView: View {
    @State private var playerCards: [Int] = []
    @State private var dealerCards: [Int] = []
    @State private var playerScore: Int = 0
    @State private var dealerScore: Int = 0
    @State private var showDealerCards = false
    @State private var gameResult: String? = nil
    @State private var isGameOver = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Правила игры \"21\" (Блэкджек)")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()

            // Dealer Section
            VStack {
                Text("Дилер")
                    .font(.headline)
                HStack {
                    ForEach(dealerCards.indices, id: \.self) { index in
                        CardView(value: dealerCards[index], hidden: !showDealerCards && index == 0)
                    }
                }
                if showDealerCards {
                    Text("Очки: \(dealerScore)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Divider()

            // Player Section
            VStack {
                Text("Игрок")
                    .font(.headline)
                HStack {
                    ForEach(playerCards, id: \.self) { card in
                        CardView(value: card)
                    }
                }
                Text("Очки: \(playerScore)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            if let result = gameResult {
                Text(result)
                    .font(.title)
                    .foregroundColor(result.contains("выиграли") ? .green : .red)
                    .padding()
            }

            // Game Controls
            if !isGameOver {
                HStack {
                    Button("More") {
                        dealCard(toPlayer: true)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Stand") {
                        endPlayerTurn()
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                Button("Новая Игра") {
                    startNewGame()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .onAppear(perform: startNewGame)
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
                isGameOver = true
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
            gameResult = "Дилер перебрал! Вы выиграли."
        } else if playerScore > dealerScore {
            gameResult = "Вы выиграли!"
        } else if playerScore == dealerScore {
            gameResult = "Ничья!"
        } else {
            gameResult = "Вы проиграли!"
        }

        isGameOver = true
    }

    func drawCard() -> Int {
        let cardValues = [2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11] // 2-10, J, Q, K, A
        return cardValues.randomElement()!
    }

    func calculateScore(for cards: [Int]) -> Int {
        var total = cards.reduce(0, +)
        var aceCount = cards.filter { $0 == 11 }.count

        // Adjust for Aces if total exceeds 21
        while total > 21 && aceCount > 0 {
            total -= 10
            aceCount -= 1
        }

        return total
    }
}

struct CardView: View {
    let value: Int
    let hidden: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(hidden ? Color.gray : Color.white)
                .frame(width: 50, height: 70)
                .shadow(radius: 5)

            if !hidden {
                Text("\(value)")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }

    init(value: Int, hidden: Bool = false) {
        self.value = value
        self.hidden = hidden
    }
}

struct BlackjackView_Previews: PreviewProvider {
    static var previews: some View {
        BlackjackView()
    }
}
