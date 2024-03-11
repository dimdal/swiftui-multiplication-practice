//
//  AnsweredQuestion.swift
//  Multiplications
//
//  Created by Marius Ørvik on 11/03/2024.
//

import SwiftUI

struct AnsweredQuestion: Identifiable {
    let question: MultiplicationQuestion
    let userAnswer: String
    var isCorrect: Bool {
        guard let userAnswerInt = Int(userAnswer) else { return false }
        return question.answer == userAnswerInt
    }
    let id = UUID()
}
