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

public struct WorkoutExerciseUserDefined: Equatable {
    public var repeats: Int
    public var weight: Double
}

public enum WorkoutStep {
    case idle
    case loading
    case loaded
}

public struct WorkoutState: Equatable {
    public var workout: Workout?
    public var exercises: [WorkoutExercise]
    public var userDefined: [String: WorkoutExerciseUserDefined]
    public var step: WorkoutStep

    public init(workout: Workout?,
                exercises: [WorkoutExercise],
                userDefined: [String: WorkoutExerciseUserDefined],
                step: WorkoutStep) {
        self.exercises = exercises
        self.userDefined = userDefined
        self.step = step
    }
}

extension WorkoutState {
    public static let initial: WorkoutState = .init(workout: nil, exercises: [], userDefined: [:], step: .idle)
}

public enum WorkoutAction {
    case loadExercises
    case exercisesLoaded([WorkoutExercise])
    case selectWorkout(id: String)
    case logExerciseResult(id: String)
    case exerciseResultLogged(id: String)
    case increaseUserDefined(id: String)
    case decreaseUserDefined(id: String)
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
        if let userDefined = state.userDefined[selected.id] {
            state.step = .loading
            return [environment.logExerciseResult((selected.id, userDefined.repeats, userDefined.weight))]
        } else {
            state.userDefined[selected.id] = .init(repeats: selected.repeats, weight: selected.weight)
            return []
        }
    case .exerciseResultLogged(let id):
        if let index = state.exercises.lastIndex(where: { $0.id == id }), let repeats = state.userDefined[id]?.repeats {
            state.exercises[index].repeats = repeats
        }
        state.userDefined.removeValue(forKey: id)
        state.step = .loaded
        return []
    case .increaseUserDefined(id: let id):
        guard let repeats = state.userDefined[id]?.repeats else { return [] }
        state.userDefined[id]?.repeats = repeats + 1
        return []
    case .decreaseUserDefined(id: let id):
        guard let repeats = state.userDefined[id]?.repeats, repeats > 0 else { return [] }
        state.userDefined[id]?.repeats = repeats - 1
        return []
    }
}

extension WorkoutState {
    func userDefinedRepeats(id: String) -> Int {
        guard let repeats = self.userDefined[id]?.repeats
            else { return self.exercises.first(where: { $0.id == id }).map { $0.repeats } ?? 0 }
        return repeats
    }
}
