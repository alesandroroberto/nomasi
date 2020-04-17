//
//  ExerciseGroupsState.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 13.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture

public struct ExerciseGroup: Equatable, Decodable {
    public var id: String
    public var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

public enum ExerciseGroupsStep {
    case idle
    case loading
    case loaded
}

public struct ExerciseGroupsState: Equatable {
    public var groups: [ExerciseGroup]
    public var step: ExerciseGroupsStep
    public var exercisesState: ExercisesState
    
    public init(groups: [ExerciseGroup],
                step: ExerciseGroupsStep,
                exercisesState: ExercisesState = .initial) {
        self.groups = groups
        self.step = step
        self.exercisesState = exercisesState
    }
}

extension ExerciseGroupsState {
    public static let initial: ExerciseGroupsState = .init(groups: [], step: .idle)
}

public enum ExerciseGroupsAction {
    case viewDidLoad
    case disappeared
    case groupsLoaded([ExerciseGroup])
    case groupSelected(id: String)
    case loadExercises
    case lastViewInStack
}

public func exerciseGroupsReducer(
    state: inout ExerciseGroupsState,
    action: ExerciseGroupsAction,
    environment: ExerciseGroupsEnvironment
) -> [Effect<ExerciseGroupsAction>] {
    switch action {
    case .viewDidLoad:
        guard state.step == .idle else { return [] }
        state.step = .loading
        return [environment.loadGroups()]
    case .groupsLoaded(let groups):
        state.step = .loaded
        state.groups = groups
        return []
    case .groupSelected(let id):
        guard state.exercisesState.group?.id != id else { return [] }
        state.exercisesState.group = state.groups.first(where: { $0.id == id })
        return [.sync(work: { .loadExercises })]
    case .disappeared:
        return []
    case .lastViewInStack:
        state.exercisesState.group = nil
        return []
    case .loadExercises:
        return []
    }
}
