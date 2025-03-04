//
//  ContentView.swift
//  Lab assignment
//
//  Created by Nilam Pancholi
//

import SwiftUI

struct PrimeCheckerView: View {
    @State private var currentNumber = Int.random(in: 2...100)
    @State private var userAnswer: Bool?
    @State private var correctAnswers = 0
    @State private var incorrectAnswers = 0
    @State private var attempts = 0
    @State private var showAlert = false
    @State private var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 5
    @State private var showingResults = false

    var body: some View {
        VStack {
            Text("Is \(currentNumber) Prime?")
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: {
                    checkAnswer(isPrime: true)
                }) {
                    Label("Prime", systemImage: "checkmark.circle")
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    checkAnswer(isPrime: false)
                }) {
                    Label("Not Prime", systemImage: "x.circle")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .disabled(userAnswer != nil)

            if let answer = userAnswer {
                Image(systemName: answer ? "checkmark.circle.fill" : "x.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(answer ? .green : .red)
                    .padding()
            }

            Text("Time Remaining: \(timeRemaining)")
                .font(.headline)
                .padding()

        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Results"), message: Text("Correct: \(correctAnswers)\nIncorrect: \(incorrectAnswers)"), dismissButton: .default(Text("OK")) {
                attempts = 0
                correctAnswers = 0
                incorrectAnswers = 0
            })
        }
        .onAppear{
            generateNewNumber()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timeRemaining = 5
                checkAnswer(isPrime: !isPrime(currentNumber))
            }
        }
    }

    func checkAnswer(isPrime userGuess: Bool) {
        let actualPrime = isPrime(currentNumber)
        if userGuess == actualPrime {
            correctAnswers += 1
            userAnswer = true
        } else {
            incorrectAnswers += 1
            userAnswer = false
        }
        attempts += 1

        if attempts >= 10 {
            showAlert = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            userAnswer = nil
            generateNewNumber()
            timeRemaining = 5 // Reset timer
        }
    }


    func generateNewNumber() {
        currentNumber = Int.random(in: 2...100)
    }

    func isPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        for i in 2...Int(sqrt(Double(number))) {
            if number % i == 0 {
                return false
            }
        }
        return true
    }
}


struct PrimeCheckerView_Previews: PreviewProvider {
    static var previews: some View {
        PrimeCheckerView()
    }
}


