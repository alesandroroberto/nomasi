//
//  ExercisesGroupsWithExercisesState.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 17.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import CasePaths
import ComposableArchitecture

public struct ExercisesGroupsWithExercisesState: Equatable {
    public var exerciseGroupsState: ExerciseGroupsState
}

extension ExercisesGroupsWithExercisesState {
    public static let initial = ExercisesGroupsWithExercisesState(exerciseGroupsState: .initial)
}

public enum ExercisesGroupsWithExercisesAction {
    case exerciseGroupsView(ExerciseGroupsAction)
    case exercisesWithDetalsView(ExercisesWithDetalsAction)
}

extension ExercisesGroupsWithExercisesState {
    public var exercisesWithDetalsView: ExercisesWithDetalsState {
        get {
            ExercisesWithDetalsState(exercisesState: exerciseGroupsState.exercisesState)
        }
        set {
            self.exerciseGroupsState.exercisesState = newValue.exercisesState
        }
    }
}

public struct ExercisesGroupsWithExercisesEnvironment {
    public let exerciseGroupsEnvironment: ExerciseGroupsEnvironment
    public let exercisesWithDetalsEnvironment: ExercisesWithDetalsEnvironment
    
    public init(exerciseGroupsEnvironment: ExerciseGroupsEnvironment,
                exercisesWithDetalsEnvironment: ExercisesWithDetalsEnvironment) {
        self.exerciseGroupsEnvironment = exerciseGroupsEnvironment
        self.exercisesWithDetalsEnvironment = exercisesWithDetalsEnvironment
    }
}

public func groupsWithExercisesReducer(
  _ reducer: @escaping Reducer<ExercisesGroupsWithExercisesState, ExercisesGroupsWithExercisesAction, ExercisesGroupsWithExercisesEnvironment>
) -> Reducer<ExercisesGroupsWithExercisesState, ExercisesGroupsWithExercisesAction, ExercisesGroupsWithExercisesEnvironment> {
    return { state, action, environment in
        let effects = reducer(&state, action, environment)
        let additionalEffects: [Effect<ExercisesGroupsWithExercisesAction>]
        switch action {
        case .exerciseGroupsView(.loadExercises):
            additionalEffects = [.sync(work: { .exercisesWithDetalsView(.exercisesView(.loadExercises)) })]
        case .exercisesWithDetalsView(.exercisesView(.selectGroup(let groupId))):
            additionalEffects = [.sync(work: { .exerciseGroupsView(.groupSelected(id: groupId)) })]
        default:
            additionalEffects = []
        }
        return additionalEffects + effects
    }
}

public typealias GroupsReducer = Reducer<ExercisesGroupsWithExercisesState,
    ExercisesGroupsWithExercisesAction,
    ExercisesGroupsWithExercisesEnvironment>

public let groupsReducer: GroupsReducer = combine(
    pullback(exercisesWithDetailsReducer(exercisesDetailsReducer),
             value: \ExercisesGroupsWithExercisesState.exercisesWithDetalsView,
             action: /ExercisesGroupsWithExercisesAction.exercisesWithDetalsView,
             environment: { $0.exercisesWithDetalsEnvironment }),
    pullback(exerciseGroupsReducer,
             value: \ExercisesGroupsWithExercisesState.exerciseGroupsState,
             action: /ExercisesGroupsWithExercisesAction.exerciseGroupsView,
             environment: { $0.exerciseGroupsEnvironment })
)
