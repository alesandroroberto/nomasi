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
    public var logExerciseResult: (WorkoutExercise) -> Effect<WorkoutAction>
    
    public init(loadExercises: @escaping (WorkoutId) -> Effect<WorkoutAction>,
                logExerciseResult: @escaping (WorkoutExercise) -> Effect<WorkoutAction>) {
        self.loadExercises = loadExercises
        self.logExerciseResult = logExerciseResult
    }
}

extension WorkoutEnvironment {
    public static let mock = WorkoutEnvironment(loadExercises: { _ in .sync(work: { .exercisesLoaded([]) }) },
                                                logExerciseResult: { _ in .sync(work: { .exerciseResultLogged }) })
}
