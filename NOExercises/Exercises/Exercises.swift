//
//  Exercises.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 14.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import Overture
import Prelude
import SwiftUI

public struct Exercises: View {
    let groupId: String
    let title: String
    let store: Store<ExercisesWithDetalsState, ExercisesWithDetalsAction>
    @ObservedObject var viewStore: ViewStore<ExercisesState, ExercisesAction>
    public var body: some View {
        List() {
            ForEach(viewStore.value.exercises, id: \.id) { exercise in
                NavigationLink(
                    "\(exercise.name)",
                    destination: ExerciseDetails(
                        exerciseId: exercise.id,
                        title: exercise.name,
                        store: self.store.scope(
                            value: { $0.exerciseDetailsView },
                            action: { .exerciseDetailsView($0) }
                        )
                    )
                )
            }
        }
        .navigationBarTitle(title)
        .onAppear(perform: { self.viewStore.send(.selectGroup(groupsId: self.groupId)) })
        .onDisappear(perform: { self.viewStore.send(.disappeared) })
    }
    
    public init(groupId: String, title: String, store: Store<ExercisesWithDetalsState, ExercisesWithDetalsAction>) {
        self.groupId = groupId
        self.title = title
        self.store = store
        self.viewStore = store
            .scope(
                value: { $0.exercisesState },
                action: { .exercisesView($0) }
        )
            .view(removeDuplicates: ==)
    }
}

struct Exercises_Previews: PreviewProvider {
    static var previews: some View {
        let state = ExercisesWithDetalsState(exercisesState: .initial)
            |> set(\.exercisesState.exercises, exercises)
        
        return Exercises(groupId: "groupId",
                  title: "Chest",
                  store: .init(
                    initialValue: state,
                    reducer: exercisesDetailsReducer,
                    environment: ExercisesWithDetalsEnvironment(
                        exercisesEnvironment: .init(loadExercises: { _ in Effect.sync(work: { .exercisesLoaded(exercises)}) }),
                        exerciseDetailsEnvironment: .init())
            )
        )
    }

    private static let exercises: [Exercise] = [
        .init(id: "Жим лёжа", name: "Жим лёжа", description: "Жим лёжа"),
        .init(id: "Жим гантелей", name: "Жим гантелей", description: "Жим гантелей"),
        .init(id: "Отжимания", name: "Отжимания", description: "Отжимания")
    ]
}
