//
//  WorkoutState.swift
//  NOWorkout
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture

public struct WorkoutExercise: Equatable, Decodable {
    public var id: String
    public var name: String
    public var repeats: Int
    public var weight: Double

    public init(id: String, name: String, repeats: Int, weight: Double) {
        self.id = id
        self.name = name
        self.repeats = repeats
        self.weight = weight
    }
}

public enum WorkoutStep {
    case idle
    case loading
    case loaded
}

public struct WorkoutState: Equatable {
    public var workout: Workout?
    public var exercises: [WorkoutExercise]
    public var step: WorkoutStep

    public init(workout: Workout?,
                exercises: [WorkoutExercise],
                step: WorkoutStep) {
        self.exercises = exercises
        self.step = step
    }
}

extension WorkoutState {
    public static let initial: WorkoutState = .init(workout: nil, exercises: [], step: .idle)
}

public enum WorkoutAction {
    case loadExercises
    case exercisesLoaded([WorkoutExercise])
    case selectWorkout(id: String)
    case logExerciseResult(id: String)
    case exerciseResultLogged
}

public func workoutReducer(
    state: inout WorkoutState,
    action: WorkoutAction,
    environment: WorkoutEnvironment
) -> [Effect<WorkoutAction>] {
    switch action {
    case .loadExercises:
        guard let workoutId = state.workout?.id else { return [] }
        state.exercises = []
        state.step = .loading
        return [environment.loadExercises(workoutId)]
    case .exercisesLoaded(let exercises):
        state.step = .loaded
        state.exercises = exercises
        return []
    case .selectWorkout:
        return []
    case .logExerciseResult(let id):
        guard let selected = state.exercises.first(where: { $0.id == id }) else { return [] }
        state.step = .loading
        return [environment.logExerciseResult(selected)]
    case .exerciseResultLogged:
        state.step = .loaded
        return []
    }
}
