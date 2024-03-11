//
//  ContentView.swift
//  Multiplications
//
//  Created by Marius Ørvik on 05/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    enum ActiveAlert: Identifiable {
        case feedback, finalScore
        
        // Computed property to conform to `Identifiable`
        var id: Self { self }
    }
    
    @State private var multiplicationUpTo = 12
    @State private var numQuestions = 5
    @State private var questions = [MultiplicationQuestion]()
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var showingFeedback = false
    @State private var feedbackMessage = ""
    @State private var showingScoreAlert = false
    @State private var finalScoreMessage = ""
    @State private var activeAlert: ActiveAlert?
    @State private var answeredQuestions: [AnsweredQuestion] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if !questions.isEmpty {
                    Text(questions[currentQuestionIndex].questionString)
                        .font(.system(size: 72))
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    HStack {
                        TextField("Answer", text: $userAnswer)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.title) // Increase font size
                            .padding() // Add padding around the text field
                            .background(Color.white.opacity(0.9)) // Add a slightly opaque white background
                            .cornerRadius(5) // Round the corners of the background
                        
                        Button(action: submitAnswer) {
                            Text("Submit")
                                .fontWeight(.bold)
                                .foregroundColor(.white) // Text color
                                .padding(.vertical, 10) // Vertical padding
                                .padding(.horizontal, 20) // Horizontal padding
                                .background(Color.blue) // Background color of the button
                                .cornerRadius(10) // Rounded corners
                        }
                        .padding() // Add padding around the button to increase tap area
                        .shadow(radius: 5) // Optionally add a shadow for a 3D effect
                    }
                    .padding()
                    
                    ScrollView {
                        ForEach(answeredQuestions) { answeredQuestion in
                            Text("\(answeredQuestion.question.questionString): \(answeredQuestion.isCorrect ? "Correct" : "Wrong")")
                                .foregroundColor(answeredQuestion.isCorrect ? .green : .red)
                        }
                    }
                    
                    Text("Score: \(score)")
                        .font(.title)
                }
                
                Spacer()
                
                NavigationLink("Settings", destination: SettingsView(multiplicationUpTo: $multiplicationUpTo, numQuestions: $numQuestions, onSave: {
                    // Actions to regenerate questions and reset the game
                    questions = Array(generateQuestions(upTo: multiplicationUpTo, numberOfQuestions: numQuestions))
                    score = 0
                    currentQuestionIndex = 0
                    showingScoreAlert = false
                    answeredQuestions.removeAll() // Assuming you want to clear previous answers
                }))
                .padding()
            }
            .navigationTitle("Multiplication Practice")
            .alert(item: $activeAlert) { alertType in
                switch alertType {
                case .feedback:
                    return Alert(title: Text("Feedback"), message: Text(feedbackMessage), dismissButton: .default(Text("OK")) {
                        moveToNextQuestion()
                    })
                case .finalScore:
                    return Alert(title: Text("Round Over"), message: Text(finalScoreMessage), dismissButton: .default(Text("OK")) {
                        // Reset for a new round, if desired
                        currentQuestionIndex = 0
                        score = 0
                        questions = Array(generateQuestions(upTo: multiplicationUpTo, numberOfQuestions: numQuestions))
                    })
                }
            }
            
        }
        .onAppear {
            questions = Array(generateQuestions(upTo: multiplicationUpTo, numberOfQuestions: numQuestions))
        }
    }
    
    func submitAnswer() {
        guard !userAnswer.isEmpty, currentQuestionIndex < questions.count else { return }
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = Int(userAnswer) == currentQuestion.answer
        
        let answeredQuestion = AnsweredQuestion(question: currentQuestion, userAnswer: userAnswer)
        answeredQuestions.append(answeredQuestion)
        
        if isCorrect {
            score += 1 // Increment score if the answer is correct
        } else {
            if score > 0 {
                score -= 1 // Only decrement the score if it's above 0
            }
        }
        
        moveToNextQuestion()
    }
    
    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            // End of round logic
            finalScoreMessage = "Your final score is \(score)"
            activeAlert = .finalScore
            answeredQuestions.removeAll()
        }
        userAnswer = "" // Reset answer field for next question
    }
    
    func generateQuestions(upTo: Int, numberOfQuestions: Int) -> Set<MultiplicationQuestion> {
        var questions = Set<MultiplicationQuestion>()
        
        while questions.count < numberOfQuestions {
            let num1 = Int.random(in: 1...upTo)
            let num2 = Int.random(in: 1...upTo)
            let question = MultiplicationQuestion(multiplier1: num1, multiplier2: num2)
            
            questions.insert(question)
        }
        
        return questions
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
