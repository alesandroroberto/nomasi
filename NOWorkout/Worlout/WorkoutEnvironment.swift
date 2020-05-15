//
//  WorkoutEnvironment.swift
//  NOWorkout
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import Combine
import ComposableArchitecture

public struct WorkoutEnvironment {
    public typealias WorkoutId = String
    public var loadExercises: (WorkoutId) -> Effect<WorkoutAction>
    public typealias WorkoutExerciseId = String
    public typealias WorkoutRepeats = Int
    public typealias WorkoutWeight = Double
    public typealias WorkoutUser = (WorkoutExerciseId, WorkoutRepeats, WorkoutWeight)
    public var logExerciseResult: (WorkoutUser) -> Effect<WorkoutAction>
    
    public init(loadExercises: @escaping (WorkoutId) -> Effect<WorkoutAction>,
                logExerciseResult: @escaping (WorkoutUser) -> Effect<WorkoutAction>) {
        self.loadExercises = loadExercises
        self.logExerciseResult = logExerciseResult
    }
}

extension WorkoutEnvironment {
    public static let mock = WorkoutEnvironment(
        loadExercises: { _ in .sync(work: { .exercisesLoaded([]) }) },
        logExerciseResult: { _ in .sync(work: { .exerciseResultLogged(id: "") }) }
    )
}
