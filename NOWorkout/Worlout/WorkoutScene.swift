//
//  WorkoutScene.swift
//  NOWorkout
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import DesignKit
import Overture
import Prelude
import SwiftUI

public struct WorkoutScene: View {
    let workoutId: String
    let title: String
    let store: Store<WorkoutState, WorkoutAction>
    @ObservedObject var viewStore: ViewStore<WorkoutState, WorkoutAction>
    public var body: some View {
        ScrollView {
            ForEach(self.viewStore.value.exercises, id: \.id) { exercise in
                VStack {
                    HStack {
                        VStack {
                            Text(exercise.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, .gridSteps(2))
                                .padding(.top, .gridStep)
                            HStack {
                                Text("\(String(format: "%.0f", exercise.weight)) \(L10n.WorkoutScene.weightUnit)")
                                Text("|")
                                Text("\(exercise.repeats) \(L10n.WorkoutScene.repeats)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, .gridSteps(2))
                            .padding(.bottom, .gridStep)
                        }
                        Button(
                            L10n.WorkoutScene.log,
                            action: { self.viewStore.send(.logExerciseResult(id: exercise.id)) }
                        )
                            .padding(.horizontal, .gridSteps(2))
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(.gridSteps(4))
                    .padding(.horizontal, .gridSteps(2))
                    Spacer(minLength: .gridSteps(4))
                }
            }
            Text("").frame(maxWidth: .infinity)
        }
        .navigationBarTitle(title)
        .onAppear(perform: { self.viewStore.send(.selectWorkout(id: self.workoutId)) })
    }
    
    public init(workoutId: String, title: String, store: Store<WorkoutState, WorkoutAction>) {
        self.workoutId = workoutId
        self.title = title
        self.store = store
        self.viewStore = self.store.view(removeDuplicates: ==)
    }
}

struct WorkoutScene_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutScene(
            workoutId: "id1",
            title: "День груди",
            store: .init(
                initialValue: .initial |> set(\.exercises, exercises),
                reducer: workoutReducer,
                environment: .mock
            )
        )
    }
    private static let exercises: [WorkoutExercise] = [
        .init(id: "id1", name: "Жим лежа", repeats: 10, weight: 50),
        .init(id: "id2", name: "Жим лежа", repeats: 10, weight: 70),
        .init(id: "id3", name: "Жим лежа", repeats: 10, weight: 90),
        .init(id: "id4", name: "Жим гантелей", repeats: 10, weight: 30),
        .init(id: "id5", name: "Жим гантелей", repeats: 10, weight: 40)
    ]
}
