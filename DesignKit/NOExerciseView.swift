//
//  NOExerciseView.swift
//  DesignKit
//
//  Created by Alexander Krupichko on 27.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI

struct NOExerciseView: View {
    private let weight: String
    private let reps: String
    var body: some View {
        VStack() {
            HStack() {
                Text(weight)
                Text(reps)
                Spacer()
            }.frame(maxWidth: .infinity)
                .padding(.vertical, .gridSteps(4))
                .background(Color(.secondarySystemBackground))
        }
    }
    
    public init(weight: String, reps: String) {
        self.weight = weight
        self.reps = reps
    }
}

struct NOExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NOExerciseView(weight: "60.0 кг", reps: "x10")
    }
}
