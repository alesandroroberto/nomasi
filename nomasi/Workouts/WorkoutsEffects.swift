//
//  WorkoutsEffect.swift
//  nomasi
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import Combine
import NOWorkout

enum WorkoutsEffects {
    static func loadWorkouts(documents: @escaping GetDocuments<Workout>) -> () -> Effect<WorkoutsAction> {
        return {
            documents("/workouts")
                .map { WorkoutsAction.workoutsLoaded($0) }
                .catch { _ in Just(.workoutsLoaded([])) }
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        }
    }
}

extension WorkoutsEnvironment {
    static func live(provider: FirebaseProvider) -> WorkoutsEnvironment {
        .init(loadWorkouts: WorkoutsEffects.loadWorkouts(documents: provider.documents))
    }
}
