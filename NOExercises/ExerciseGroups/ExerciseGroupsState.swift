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

public enum ExerciseStep {
    case idle
    case loading
    case loaded
}

public struct ExerciseGroupsState: Equatable {
    public var groups: [ExerciseGroup]
    public var step: ExerciseStep
    
    public init(groups: [ExerciseGroup], step: ExerciseStep) {
        self.groups = groups
        self.step = step
    }
}

extension ExerciseGroupsState {
    public static let initial: ExerciseGroupsState = .init(groups: [], step: .idle)
}

public enum ExerciseGroupsAction {
    case viewDidLoad
    case groupsLoaded([ExerciseGroup])
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
    }
}
