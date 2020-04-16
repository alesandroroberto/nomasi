//
//  ExerciseDetailsState.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 15.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture

public struct ExerciseDetailsState: Equatable {
    public var exercise: Exercise?

    public init(exercise: Exercise?) {
        self.exercise = exercise
    }
}

extension ExerciseDetailsState {
    public static let initial: ExerciseDetailsState = .init(exercise: nil)
}

public enum ExerciseDetailsAction {
    case viewDidLoad
    case disappeared
    case lastViewInStack
}

public func exerciseDetailsReducer(
    state: inout ExerciseDetailsState,
    action: ExerciseDetailsAction,
    environment: ExerciseDetailsEnvironment
) -> [Effect<ExerciseDetailsAction>] {
    switch action {
    case .viewDidLoad:
        return []
    case .disappeared:
        return []
    case .lastViewInStack:
        return []
    }
}
