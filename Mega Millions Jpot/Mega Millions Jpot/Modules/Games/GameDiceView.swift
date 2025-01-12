//
//  GameDiceView.swift
//  Mega Millions Jpot
//
//  Created by Dias Atudinov on 10.01.2025.
//

import SwiftUI

struct GameDiceView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GameDiceView()
}

struct DiceGameView: View {
    @State private var playerDice: [Int] = [1, 1]
    @State private var dealerDice: [Int] = [1, 1]
    @State private var playerScore: Int = 0
    @State private var dealerScore: Int = 0
    @State private var gameResult: String? = nil
    @State private var isGameOver = false
    @State private var isRolling = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Правила игры \"Кости\" против дилера")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()

            // Player Section
            VStack {
                Text("Игрок")
                    .font(.headline)
                HStack {
                    ForEach(playerDice, id: \.self) { die in
                        DiceView(value: die)
                    }
                }
                Text("Очки: \(playerScore)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Divider()

            // Dealer Section
            VStack {
                Text("Дилер")
                    .font(.headline)
                HStack {
                    ForEach(dealerDice, id: \.self) { die in
                        DiceView(value: die)
                    }
                }
                Text("Очки: \(dealerScore)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            if let result = gameResult {
                Text(result)
                    .font(.title)
                    .foregroundColor(result.contains("выиграли") ? .green : result.contains("ничья") ? .orange : .red)
                    .padding()
            }

            // Game Controls
            if !isGameOver {
                Button("Бросить Кости") {
                    rollDice()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRolling) // Disable button while rolling
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
        playerDice = [1, 1]
        dealerDice = [1, 1]
        playerScore = 0
        dealerScore = 0
        gameResult = nil
        isGameOver = false
        isRolling = false
    }

    func rollDice() {
        isRolling = true
        gameResult = nil

        var iterations = 0
        let maxIterations = 20 // Adjust for 2 seconds (10 changes per second)

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            iterations += 1

            // Randomly change dice values during rolling
            playerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]
            dealerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]

            if iterations >= maxIterations {
                timer.invalidate() // Stop the timer after 2 seconds

                // Finalize dice values
                playerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]
                dealerDice = [Int.random(in: 1...6), Int.random(in: 1...6)]
                playerScore = playerDice.reduce(0, +)
                dealerScore = dealerDice.reduce(0, +)

                // Determine the result
                if playerScore > dealerScore {
                    gameResult = "Вы выиграли!"
                } else if playerScore < dealerScore {
                    gameResult = "Вы проиграли!"
                } else {
                    gameResult = "Ничья!"
                }

                isGameOver = true
                isRolling = false
            }
        }
    }
}

struct DiceView: View {
    let value: Int

    var body: some View {
        Image("dice\(value)")
            .resizable()
            .scaledToFit()
            .frame(height: 50)
            .shadow(radius: 5)
    }
}

struct DiceGameView_Previews: PreviewProvider {
    static var previews: some View {
        DiceGameView()
    }
}
