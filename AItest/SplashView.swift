import SwiftUI

struct SplashView: View {
    // アニメーション用のアルファベットデータ
    let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    @State private var letters: [FallingLetter] = []
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.3)
                .ignoresSafeArea()
            ForEach(letters) { letter in
                Text(String(letter.char))
                    .font(.system(size: letter.size, weight: .bold))
                    .foregroundColor(.orange)
                    .position(x: letter.x, y: letter.y)
                    .opacity(letter.opacity)
            }
            VStack {
                Spacer()
                Text("Typing Game")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.orange)
                Spacer()
            }
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startAnimation() {
        letters = []
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in // 60fpsで更新
            addLetter()
            updateLetters()
        }
    }
    
    func addLetter() {
        let char = alphabet.randomElement() ?? "A"
        let x = CGFloat.random(in: 20...UIScreen.main.bounds.width - 20)
        let size = CGFloat.random(in: 24...48)
        let speed = CGFloat.random(in: 3...7) // 文字ごとに落下速度を持たせる
        letters.append(FallingLetter(char: char, x: x, y: -30, size: size, speed: speed))
    }
    
    func updateLetters() {
        for i in letters.indices {
            letters[i].y += letters[i].speed // 一定速度で落下
            letters[i].opacity -= 0.008 // ゆっくり消える
        }
        letters.removeAll { $0.y > UIScreen.main.bounds.height + 30 || $0.opacity < 0.05 }
    }
}

struct FallingLetter: Identifiable {
    let id = UUID()
    let char: Character
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat // 追加：落下速度
    var opacity: Double = 1.0
}

#Preview {
    SplashView()
}
