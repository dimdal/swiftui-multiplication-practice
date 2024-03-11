//
//  MultiplicationQuestion.swift
//  Multiplications
//
//  Created by Marius Ørvik on 11/03/2024.
//

import SwiftUI

struct MultiplicationQuestion: Hashable {
    let multiplier1: Int
    let multiplier2: Int
    var questionString: String {
        "\(multiplier1)x\(multiplier2)"
    }
    var answer: Int {
        multiplier1 * multiplier2
    }
}
