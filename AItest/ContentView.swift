//
//  ContentView.swift
//  AItest
//
//  Created by masato on 2025/08/28.
//

import SwiftUI

struct ContentView: View {
    // タイピング用の単語リスト
    let words = ["apple", "swift", "keyboard", "computer", "game", "challenge", "score", "typing", "speed", "fun"]
    @State private var currentWordIndex = 0
    @State private var userInput = ""
    @State private var score = 0
    @State private var showCorrect = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("タイピングゲーム")
                .font(.title)
                .bold()
            Text("Score: \(score)")
                .font(.headline)
            Text(words[currentWordIndex])
                .font(.largeTitle)
                .padding()
            TextField("Type here", text: $userInput, onCommit: checkInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
            if showCorrect {
                Text("Correct!")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
    
    func checkInput() {
        if userInput == words[currentWordIndex] {
            score += 1
            showCorrect = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showCorrect = false
                nextWord()
            }
        } else {
            showCorrect = false
        }
        userInput = ""
    }
    
    func nextWord() {
        currentWordIndex = (currentWordIndex + 1) % words.count
    }
}

#Preview {
    ContentView()
}
