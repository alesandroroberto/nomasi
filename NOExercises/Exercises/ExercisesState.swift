//
//  ExercisesState.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 14.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture

public struct Exercise: Equatable, Decodable {
    public var id: String
    public var name: String
    public var description: String?

    public init(id: String, name: String, description: String?) {
        self.id = id
        self.name = name
        self.description = description
    }
}

public enum ExercisesStep {
    case idle
    case loading
    case loaded
}

public struct ExercisesState: Equatable {
    public var group: ExerciseGroup?
    public var exercises: [Exercise]
    public var step: ExercisesStep
    public var selected: Exercise?

    public init(group: ExerciseGroup?, exercises: [Exercise], step: ExercisesStep, selected: Exercise? = nil) {
        self.group = group
        self.exercises = exercises
        self.step = step
        self.selected = selected
    }
}

extension ExercisesState {
    public static let initial: ExercisesState = .init(group: nil, exercises: [], step: .idle)
}

public enum ExercisesAction {
    case viewDidLoad
    case disappeared
    case exercisesLoaded([Exercise])
    case exerciseSelected(id: String)
    case lastViewInStack
}

public func exercisesReducer(
    state: inout ExercisesState,
    action: ExercisesAction,
    environment: ExercisesEnvironment
) -> [Effect<ExercisesAction>] {
    switch action {
    case .viewDidLoad:
        guard let groupId = state.group?.id else { return [] }
        state.exercises = []
        state.step = .loading
        return [environment.loadExercises(groupId)]
    case .exercisesLoaded(let exercises):
        state.step = .loaded
        state.exercises = exercises
        return []
    case .exerciseSelected(let id):
        state.selected = state.exercises.first(where: { $0.id == id })
        return []
    case .disappeared:
        return []
    case .lastViewInStack:
        state.selected = nil
        return []
    }
}
