//
//  ExerciseGroupsEffects.swift
//  nomasi
//
//  Created by Alexander Krupichko on 13.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import Combine
import Firebase
import NOExercises
import Overture
import Prelude

enum ExerciseGroupsEffects {
    static func loadGroups(documents: @escaping GetDocuments<ExerciseGroup>) -> () -> Effect<ExerciseGroupsAction> {
        return {
            documents("/exerciseGroups")
                .map { ExerciseGroupsAction.groupsLoaded($0) }
                .catch { _ in Just(.groupsLoaded([])) }
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        }
    }
}

extension ExerciseGroupsEnvironment {
    static func live(provider: FirebaseProvider) -> ExerciseGroupsEnvironment {
        .init(loadGroups: ExerciseGroupsEffects.loadGroups(documents: provider.documents))
    }
}
