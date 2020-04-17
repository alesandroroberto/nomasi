//
//  ExercisesWithDetals.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 17.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import CasePaths
import ComposableArchitecture

public struct ExercisesWithDetalsState: Equatable {
    public var exercisesState: ExercisesState
}

public enum ExercisesWithDetalsAction {
    case exercisesView(ExercisesAction)
    case exerciseDetailsView(ExerciseDetailsAction)
}

extension ExercisesWithDetalsState {
    public var exercisesView: ExercisesState {
        get {
            ExercisesState(group: exercisesState.group,
                           exercises: exercisesState.exercises,
                           step: exercisesState.step,
                           exerciseDetailsState: exercisesState.exerciseDetailsState)
        }
        set {
            self.exercisesState.group = newValue.group
            self.exercisesState.exercises = newValue.exercises
            self.exercisesState.step = newValue.step
            self.exercisesState.exerciseDetailsState = newValue.exerciseDetailsState
        }
    }
    public var exerciseDetailsView: ExerciseDetailsState {
        get {
            ExerciseDetailsState(exercise: exercisesState.exerciseDetailsState.exercise)
        }
        set {
            self.exercisesState.exerciseDetailsState.exercise = newValue.exercise
        }
    }
}

public struct ExercisesWithDetalsEnvironment {
    public let exercisesEnvironment: ExercisesEnvironment
    public let exerciseDetailsEnvironment: ExerciseDetailsEnvironment
    
    public init(exercisesEnvironment: ExercisesEnvironment,
                exerciseDetailsEnvironment: ExerciseDetailsEnvironment) {
        self.exercisesEnvironment = exercisesEnvironment
        self.exerciseDetailsEnvironment = exerciseDetailsEnvironment
    }
}

public func exercisesWithDetailsReducer(
  _ reducer: @escaping Reducer<ExercisesWithDetalsState, ExercisesWithDetalsAction, ExercisesWithDetalsEnvironment>
) -> Reducer<ExercisesWithDetalsState, ExercisesWithDetalsAction, ExercisesWithDetalsEnvironment> {
    return { state, action, environment in
        let effects = reducer(&state, action, environment)
        let additionalEffects: [Effect<ExercisesWithDetalsAction>]
        switch action {
        case .exerciseDetailsView(.selectExercise(let exerciseId)):
            additionalEffects = [.sync(work: { .exercisesView(.exerciseSelected(id: exerciseId)) })]
        default:
            additionalEffects = []
        }
        return additionalEffects + effects
    }
}

public let exercisesDetailsReducer: Reducer<ExercisesWithDetalsState, ExercisesWithDetalsAction, ExercisesWithDetalsEnvironment>
    = combine(
        pullback(exercisesReducer,
                 value: \ExercisesWithDetalsState.exercisesState,
                 action: /ExercisesWithDetalsAction.exercisesView,
                 environment: { $0.exercisesEnvironment }),
        pullback(exerciseDetailsReducer,
                 value: \ExercisesWithDetalsState.exerciseDetailsView,
                 action: /ExercisesWithDetalsAction.exerciseDetailsView,
                 environment: { $0.exerciseDetailsEnvironment })
)
