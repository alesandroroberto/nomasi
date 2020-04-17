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
    let store: Store<ExercisesGroupsWithExercisesState, ExercisesGroupsWithExercisesAction>
    @ObservedObject var viewStore: ViewStore<ExerciseGroupsState, ExerciseGroupsAction>
    
    public var body: some View {
        NavigationView() {
            List() {
                ForEach(viewStore.value.groups, id: \.id) { group in
                    NavigationLink(
                        "\(group.name)",
                        destination: Exercises(groupId: group.id,
                                               title: group.name,
                                               store: self.store.scope(
                                                value: { $0.exercisesWithDetalsView },
                                                action: { .exercisesWithDetalsView($0) }
                            )
                        )
                    )
                }
            }
            .onAppear(perform: { self.viewStore.send(.viewDidLoad); print("ExerciseGroups appear") })
            .onDisappear(perform: { self.viewStore.send(.disappeared); print("ExerciseGroups Disappear") })
            .navigationBarTitle("Группы")
        }
    }
    
    public init(store: Store<ExercisesGroupsWithExercisesState, ExercisesGroupsWithExercisesAction>) {
        self.store = store
        self.viewStore = self.store
            .scope(value: { $0.exerciseGroupsState },
                   action: { .exerciseGroupsView($0) })
            .view(removeDuplicates: ==)
    }
}

//struct ExerciseGroups_Previews: PreviewProvider {
//    static var previews: some View {
//        return ExerciseGroups(
//            store: .init(
//                initialValue: .initial,
//                reducer: exerciseGroupsReducer,
//                environment: ExerciseGroupsEnvironment(
//                    loadGroups: { Effect.sync(work: { .groupsLoaded(groups) }) }
//                )
//            ), exercisesStore: .init(
//                initialValue: .initial,
//                reducer: exercisesReducer,
//                environment: ExercisesEnvironment(
//                    loadExercises: { _ in Effect.sync(work: { .exercisesLoaded([]) }) }
//                )
//            ), exerciseDetails: .init(
//                initialValue: .initial,
//                reducer: exerciseDetailsReducer,
//                environment: ExerciseDetailsEnvironment()
//            )
//        )
//    }
//
//    private static let groups: [ExerciseGroup] = [
//        .init(id: "Грудь", name: "Грудь"),
//        .init(id: "Руки", name: "Руки"),
//        .init(id: "Ноги", name: "Ноги"),
//        .init(id: "Спина", name: "Спина")
//    ]
//}
