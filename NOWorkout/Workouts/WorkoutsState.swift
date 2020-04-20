//
//  WorkoutsState.swift
//  NOWorkout
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture

public struct Workout: Equatable, Decodable {
    public var id: String
    public var name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public enum WorkoutsStep {
    case idle
    case loading
    case loaded
}

public struct WorkoutsState: Equatable {
    public var workouts: [Workout]
    public var step: WorkoutsStep
    public var workoutState: WorkoutState

    public init(workouts: [Workout],
                step: WorkoutsStep,
                workoutState: WorkoutState) {
        self.workouts = workouts
        self.step = step
        self.workoutState = workoutState
    }
}

extension WorkoutsState {
    public static let initial: WorkoutsState = .init(workouts: [], step: .idle, workoutState: .initial)
}

public enum WorkoutsAction {
    case loadWorkouts
    case workoutsLoaded([Workout])
    case workoutSelected(id: String)
    case loadExercises
}

public func workoutsReducer(
    state: inout WorkoutsState,
    action: WorkoutsAction,
    environment: WorkoutsEnvironment
) -> [Effect<WorkoutsAction>] {
    switch action {
    case .loadWorkouts:
        guard state.step == .idle else { return [] }
        state.step = .loading
        return [environment.loadWorkouts()]
    case .workoutsLoaded(let workouts):
        state.step = .loaded
        state.workouts = workouts
        return []
    case .workoutSelected(let id):
        state.workoutState.workout = state.workouts.first(where: { $0.id == id })
        return [.sync(work: { .loadExercises })]
    case .loadExercises:
        return []
    }
}
