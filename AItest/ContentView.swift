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
    @State private var timeLeft = 30
    @State private var timer: Timer? = nil
    @State private var isGameActive = false
    @State private var showTimeUp = false
    @State private var showHistory = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("タイピングゲーム")
                    .font(.title)
                    .bold()
                Text("Score: \(score)")
                    .font(.headline)
                Text("Time: \(timeLeft)")
                    .font(.headline)
                    .foregroundColor(.red)
                if showTimeUp {
                    Text("Time Up!")
                        .foregroundColor(.blue)
                }
                Text(words[currentWordIndex])
                    .font(.largeTitle)
                    .padding()
                TextField("", text: $userInput, onCommit: checkInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .disabled(!isGameActive)
                    .focused($isTextFieldFocused)
                if showCorrect {
                    Text("Correct!")
                        .foregroundColor(.green)
                }
                Button(isGameActive ? "リセット" : "スタート") {
                    if isGameActive {
                        resetGame()
                    } else {
                        startGame()
                    }
                }
                .padding()
                Button("履歴を見る") {
                    showHistory = true
                }
                .padding()
            }
            .padding()
            .onAppear {
                loadHistory()
            }
            .navigationDestination(isPresented: $showHistory) {
                HistoryView()
            }
        }
    }
    
    func startGame() {
        score = 0
        currentWordIndex = 0
        timeLeft = 30
        isGameActive = true
        showTimeUp = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
                if timeLeft == 0 {
                    timeUp()
                }
            }
        }
    }
    
    func timeUp() {
        isGameActive = false
        showTimeUp = true
        timer?.invalidate()
        saveScore(score)
    }
    
    func resetGame() {
        timer?.invalidate()
        isGameActive = false
        showTimeUp = false
        score = 0
        timeLeft = 30
        userInput = ""
        currentWordIndex = 0
    }
    
    func checkInput() {
        guard isGameActive else { return }
        if userInput == words[currentWordIndex] {
            score += 1
            showCorrect = true
            userInput = ""
            isTextFieldFocused = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isTextFieldFocused = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showCorrect = false
                nextWord()
            }
        } else {
            showCorrect = false
            userInput = ""
        }
    }
    
    func nextWord() {
        currentWordIndex = (currentWordIndex + 1) % words.count
    }
    
    func saveScore(_ newScore: Int) {
        var history = UserDefaults.standard.array(forKey: "scoreHistory") as? [Int] ?? []
        history.append(newScore)
        history = Array(history.sorted(by: >).prefix(5))
        UserDefaults.standard.set(history, forKey: "scoreHistory")
    }
    
    func loadHistory() {
        let history = UserDefaults.standard.array(forKey: "scoreHistory") as? [Int] ?? []
    }
}

#Preview {
    ContentView()
}
