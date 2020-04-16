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
    let exerciseDetails: Store<ExerciseDetailsState, ExerciseDetailsAction>
    @ObservedObject var viewStore: ViewStore<ExercisesState, ExercisesAction>
    public var body: some View {
        List() {
            ForEach(viewStore.value.exercises, id: \.id) { exercise in
//                NavigationLink(
//                    destination: ExerciseDetails(store: self.exerciseDetails),
//                    tag: exercise.id,
//                    selection: .constant(self.viewStore.value.selected?.id),
//                    label: {
//                        Text("\(exercise.name)")
//                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                            .background(Color(.systemBackground))
//                            .onTapGesture() { self.viewStore.send(.exerciseSelected(id: exercise.id)) }
//                }
//                )
                Text("\(exercise.name)")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .onTapGesture() { self.viewStore.send(.exerciseSelected(id: exercise.id)) }
            }
            NavigationLink(destination: ExerciseDetails(store: self.exerciseDetails),
                           isActive: .constant(self.viewStore.value.selected?.id != nil),
                           label: { EmptyView() })
        }
        .navigationBarTitle(viewStore.value.group?.name ?? "")
        .onAppear(perform: { self.viewStore.send(.viewDidLoad); print("Exercises appear") })
        .onDisappear(perform: { self.viewStore.send(.disappeared); print("Exercises Disappear") })
    }
    
    public init(store: Store<ExercisesState, ExercisesAction>,
                exerciseDetails: Store<ExerciseDetailsState, ExerciseDetailsAction>) {
        self.store = store
        self.exerciseDetails = exerciseDetails
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
            ), exerciseDetails: .init(
                initialValue: .initial,
                reducer: exerciseDetailsReducer,
                environment: ExerciseDetailsEnvironment()
            ))
    }
    
    private static let exercises: [Exercise] = [
        .init(id: "Жим лёжа", name: "Жим лёжа", description: "Жим лёжа"),
        .init(id: "Жим гантелей", name: "Жим гантелей", description: "Жим гантелей"),
        .init(id: "Отжимания", name: "Отжимания", description: "Отжимания")
    ]
}
