//
//  SettingsView.swift
//  Multiplications
//
//  Created by Marius Ørvik on 11/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var multiplicationUpTo: Int
    @Binding var numQuestions: Int
    @Environment(\.presentationMode) var presentationMode

    var onSave: () -> Void
    
    var body: some View {
        List {
            Stepper("Up to \(multiplicationUpTo)", value: $multiplicationUpTo, in: 2...12)
            Stepper("Questions: \(numQuestions)", value: $numQuestions, in: 5...20, step: 5)
            Button("Save") {
                onSave() // Assume this triggers the necessary actions in ContentView
                presentationMode.wrappedValue.dismiss() // Dismiss SettingsView to show the changes took effect
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(10)
        }
        .navigationTitle("Settings")

    }
}
