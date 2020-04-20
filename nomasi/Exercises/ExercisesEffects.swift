//
//  ExercisesEffects.swift
//  nomasi
//
//  Created by Alexander Krupichko on 14.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import Combine
import NOExercises
import Overture
import Prelude

enum ExercisesEffects {
    static func loadExercises(documents: @escaping GetDocuments<Exercise>)
        -> (ExercisesEnvironment.GroupId) -> Effect<ExercisesAction> {
        return { groupId in
            documents("/exerciseGroups/" + groupId + "/exercises")
                .map { ExercisesAction.exercisesLoaded($0) }
                .catch { _ in Just(.exercisesLoaded([])) }
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        }
    }
}

extension ExercisesEnvironment {
    static func live(provider: FirebaseProvider) -> ExercisesEnvironment {
        .init(loadExercises: ExercisesEffects.loadExercises(documents: provider.documents))
    }
}
