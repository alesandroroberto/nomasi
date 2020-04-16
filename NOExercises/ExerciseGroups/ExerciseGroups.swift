//
//  ExerciseGroups.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 13.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct ExerciseGroups: View {
    let store: Store<ExerciseGroupsState, ExerciseGroupsAction>
    let exercisesStore: Store<ExercisesState, ExercisesAction>
    let exerciseDetails: Store<ExerciseDetailsState, ExerciseDetailsAction>
    @ObservedObject var viewStore: ViewStore<ExerciseGroupsState, ExerciseGroupsAction>
    
    public var body: some View {
        NavigationView() {
            List() {
                ForEach(viewStore.value.groups, id: \.id) { group in
//                    NavigationLink(
//                        destination: Exercises(store: self.exercisesStore, exerciseDetails: self.exerciseDetails),
//                        tag: group.id,
//                        selection: .constant(self.viewStore.value.selected?.id),
//                        label: {
//                            Text("\(group.name)")
//                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                                .background(Color(.systemBackground))
//                                .onTapGesture() {
//                                    self.viewStore.send(.groupSelected(id: group.id))
//                            }
//                    }
//                    )
                    Text("\(group.name)")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemBackground))
                        .onTapGesture() {
                            self.viewStore.send(.groupSelected(id: group.id))
                    }
                }
                NavigationLink(destination: Exercises(store: self.exercisesStore, exerciseDetails: self.exerciseDetails),
                               isActive: .constant(self.viewStore.value.selected?.id != nil),
                               label: { EmptyView() })
            }
            .onAppear(perform: { self.viewStore.send(.viewDidLoad); print("ExerciseGroups appear") })
            .onDisappear(perform: { self.viewStore.send(.disappeared); print("ExerciseGroups Disappear") })
            .navigationBarTitle("Группы")
        }
    }
    
    public init(store: Store<ExerciseGroupsState, ExerciseGroupsAction>,
                exercisesStore: Store<ExercisesState, ExercisesAction>,
                exerciseDetails: Store<ExerciseDetailsState, ExerciseDetailsAction>) {
        self.store = store
        self.exercisesStore = exercisesStore
        self.exerciseDetails = exerciseDetails
        self.viewStore = self.store.view(removeDuplicates: ==)
    }
}

struct ExerciseGroups_Previews: PreviewProvider {
    static var previews: some View {
        return ExerciseGroups(
            store: .init(
                initialValue: .initial,
                reducer: exerciseGroupsReducer,
                environment: ExerciseGroupsEnvironment(
                    loadGroups: { Effect.sync(work: { .groupsLoaded(groups) }) }
                )
            ), exercisesStore: .init(
                initialValue: .initial,
                reducer: exercisesReducer,
                environment: ExercisesEnvironment(
                    loadExercises: { _ in Effect.sync(work: { .exercisesLoaded([]) }) }
                )
            ), exerciseDetails: .init(
                initialValue: .initial,
                reducer: exerciseDetailsReducer,
                environment: ExerciseDetailsEnvironment()
            )
        )
    }
    
    private static let groups: [ExerciseGroup] = [
        .init(id: "Грудь", name: "Грудь"),
        .init(id: "Руки", name: "Руки"),
        .init(id: "Ноги", name: "Ноги"),
        .init(id: "Спина", name: "Спина")
    ]
}
