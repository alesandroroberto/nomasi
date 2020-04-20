//
//  WorkoutsWithDetails.swift
//  NOWorkout
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import CasePaths
import ComposableArchitecture

public struct WorkoutsWithDetailsState: Equatable {
    public var workoutsState: WorkoutsState
}

extension WorkoutsWithDetailsState {
    public static let initial = WorkoutsWithDetailsState(workoutsState: .initial)
}

public enum WorkoutsWithDetailsAction {
    case workoutsView(WorkoutsAction)
    case workoutView(WorkoutAction)
}

extension WorkoutsWithDetailsState {
    public var workoutView: WorkoutState {
        get {
            self.workoutsState.workoutState
        }
        set {
            self.workoutsState.workoutState = newValue
        }
    }
}

public struct WorkoutsWithDetailsEnvironment {
    public let workoutsEnvironment: WorkoutsEnvironment
    public let workoutEnvironment: WorkoutEnvironment
    
    public init(workoutsEnvironment: WorkoutsEnvironment,
                workoutEnvironment: WorkoutEnvironment) {
        self.workoutsEnvironment = workoutsEnvironment
        self.workoutEnvironment = workoutEnvironment
    }
     
    public static let mock = WorkoutsWithDetailsEnvironment(workoutsEnvironment: .mock, workoutEnvironment: .mock)
}

public func workoutsWithDetailsConnectReducer(
  _ reducer: @escaping WorkoutsWithDetailsReducer
) -> WorkoutsWithDetailsReducer {
    return { state, action, environment in
        let effects = reducer(&state, action, environment)
        let additionalEffects: [Effect<WorkoutsWithDetailsAction>]
        switch action {
        case .workoutsView(.loadExercises):
            additionalEffects = [.sync(work: { .workoutView(.loadExercises) })]
        case .workoutView(.selectWorkout(let id)):
            additionalEffects = [.sync(work: { .workoutsView(.workoutSelected(id: id)) })]
        default:
            additionalEffects = []
        }
        return additionalEffects + effects
    }
}

public typealias WorkoutsWithDetailsReducer = Reducer<WorkoutsWithDetailsState,
    WorkoutsWithDetailsAction,
    WorkoutsWithDetailsEnvironment>

public let workoutsWithDetailsReducer: WorkoutsWithDetailsReducer = combine(
    pullback(workoutsReducer,
             value: \.workoutsState,
             action: /WorkoutsWithDetailsAction.workoutsView,
             environment: { $0.workoutsEnvironment }),
    pullback(workoutReducer,
             value: \WorkoutsWithDetailsState.workoutView,
             action: /WorkoutsWithDetailsAction.workoutView,
             environment: { $0.workoutEnvironment })
)
