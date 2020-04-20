//
//  WorkoutEnvironment.swift
//  NOWorkout
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import Combine
import ComposableArchitecture

public struct WorkoutsEnvironment {
    public var loadWorkouts: () -> Effect<WorkoutsAction>
    
    public init(loadWorkouts: @escaping () -> Effect<WorkoutsAction>) {
        self.loadWorkouts = loadWorkouts
    }
}

extension WorkoutsEnvironment {
    static let mock = WorkoutsEnvironment(loadWorkouts: { .sync(work: { .workoutsLoaded([]) }) })
}
