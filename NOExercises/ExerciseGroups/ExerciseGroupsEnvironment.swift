//
//  ExerciseGroupsEnvironment.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 13.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import Combine
import ComposableArchitecture

public struct ExerciseGroupsEnvironment {
    public var loadGroups: () -> Effect<ExerciseGroupsAction>
    
    public init(loadGroups: @escaping () -> Effect<ExerciseGroupsAction>) {
        self.loadGroups = loadGroups
    }
}
