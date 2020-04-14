//
//  Exercises.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 14.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct Exercises: View {
    let store: Store<ExercisesState, ExercisesAction>
    @ObservedObject var viewStore: ViewStore<ExercisesState, ExercisesAction>
    public var body: some View {
        List() {
            ForEach(viewStore.value.exercises, id: \.id) { exercise in
                NavigationLink("\(exercise.name)", destination: Text("\(exercise.name)"))
            }
        }
        .navigationBarTitle(viewStore.value.group?.name ?? "")
        .onAppear(perform: { self.viewStore.send(.viewDidLoad) })
        .onDisappear(perform: { self.viewStore.send(.disappear) })
    }
    
    public init(store: Store<ExercisesState, ExercisesAction>) {
        self.store = store
        self.viewStore = self.store.view(removeDuplicates: ==)
    }
}

struct Exercises_Previews: PreviewProvider {
    static var previews: some View {
        Exercises(store: .init(
            initialValue: .initial,
            reducer: exercisesReducer,
            environment: ExercisesEnvironment(
                loadExercises: { _ in Effect.sync(work: { .exercisesLoaded(exercises) }) }
            )
        ))
    }
    
    private static let exercises: [Exercise] = [
        .init(id: "Жим лёжа", name: "Жим лёжа"),
        .init(id: "Жим гантелей", name: "Жим гантелей"),
        .init(id: "Отжимания", name: "Отжимания")
    ]
}
