//
//  ExercisesEnvironment.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 14.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import Combine
import ComposableArchitecture

public struct ExercisesEnvironment {
    public typealias GroupId = String
    public var loadExercises: (GroupId) -> Effect<ExercisesAction>
    
    public init(loadExercises: @escaping (GroupId) -> Effect<ExercisesAction>) {
        self.loadExercises = loadExercises
    }
}
