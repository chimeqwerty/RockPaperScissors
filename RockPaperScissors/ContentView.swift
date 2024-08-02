//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Jan Halas on 30.7.2024.
//

import SwiftUI
// https://www.youtube.com/watch?v=lB4FiWAbefM&ab_channel=OliverBaumeister


enum playAlternatives: String, CaseIterable {
    
    case Rock = "🪨",
         
         Scissors = "✂️",
         
         Paper = "🧻"
    
}



struct ContentView: View {
    
    
    @State private var computerChoice = playAlternatives.allCases.first!
    @State private var gameOutcome = ""
    
    @State private var wins = 0
    @State private var round = 0
    
    @State private var showAlert = false
    @State private var showComputerChoice = false
    
    
    func checkWin(playerChoice: playAlternatives) {
        switch playerChoice {
        case .Scissors:
            if computerChoice == .Scissors {
                gameOutcome = "Draw"
            } else if computerChoice == .Paper {
                gameOutcome = "Win"
                wins += 1
            } else {
                gameOutcome = "Lose"
                wins += -1
                
            }
        case .Paper:
            if computerChoice == .Scissors {
                gameOutcome = "Lose"
                wins += -1
            } else if computerChoice == .Paper {
                gameOutcome = "Draw"
            } else {
                gameOutcome = "Win"
                wins += 1
            }
        case .Rock:
            if computerChoice == .Scissors {
                gameOutcome = "Win"
                wins += 1
            } else if computerChoice == .Paper {
                gameOutcome = "Lose"
                wins += -1
            } else {
                gameOutcome = "Draw"
            }
        }
        showAlert = true
    }
    
    // function to restart the game -> reset wins and round-values
    func restartGame () {
        wins = 0
        round = 0
    }
    
    var body: some View {
        
        
        NavigationStack {
            
            
            VStack {
                
                //Computer-side
                VStack {
                    
                    if !showComputerChoice  {
                        Text("Waiting on your move")
                            .font(.system(size: 30))
                    } else {
                        Text(computerChoice.rawValue)
                    }
                }
                .padding(40)
                
                // Player side
                VStack {
                    Text("Select your move:")
                    HStack {
                        ForEach(playAlternatives.allCases, id: \.self) { selection in
                            Button(action: {
                                
                                round += 1
                                
                                // generate CPU choice
                                let index = Int.random(in: 0...playAlternatives.allCases.count-1)
                                
                                computerChoice = playAlternatives.allCases[index]
                                
                                showComputerChoice = true
                                
                                // Check if win
                                checkWin(playerChoice: selection)
                                
                            })
                            
                            {
                                Text(selection.rawValue)
                                
                            }
                        }
                    }
                    
                    
                    HStack {
                        Spacer()
                        Text("Wins: \(max(wins, 0))")
                        Spacer()
                        Text("Rounds: \(round)")
                        Spacer()
                    }
                    .padding()
                    
                } .font(.system(size: 30))
                    .navigationTitle("Rock Paper Scissors")
                    .toolbar {
                        ToolbarItem {
                            Button("Restart game", action: { restartGame() })
                        }
                    }
                
                    .alert("You \(gameOutcome)", isPresented: $showAlert) {
                        if round != 10 {
                            Button("Continue", role: .cancel)
                            {showComputerChoice = false}
                        } else {
                            Button("Restart Game", action: restartGame)
                        }
                    } message: {
                        if round != 10 {
                            Text("Your current score is \(max(wins, 0))")
                        } else {
                            Text("Game ended, you scored \(wins). Wanna replay? Hit the restart button")
                        }
                        
                    }
                
            }
        }
    }
}




#Preview {
    ContentView()
}
