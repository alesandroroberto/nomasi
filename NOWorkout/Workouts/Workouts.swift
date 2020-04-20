//
//  Workouts.swift
//  NOWorkout
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import Overture
import Prelude
import SwiftUI

public struct Workouts: View {
    let store: Store<WorkoutsWithDetailsState, WorkoutsWithDetailsAction>
    @ObservedObject var viewStore: ViewStore<WorkoutsState, WorkoutsAction>
    public var body: some View {
        NavigationView() {
            List() {
                ForEach(viewStore.value.workouts, id: \.id) { workout in
                    NavigationLink(
                        workout.name,
                        destination: WorkoutScene(
                            workoutId: workout.id,
                            title: workout.name,
                            store: self.store.scope(
                                value: { $0.workoutView },
                                action: { .workoutView($0) }
                            )
                        )
                    )
                }
            }
            .onAppear(perform: { self.viewStore.send(.loadWorkouts) })
            .navigationBarTitle(L10n.Workouts.title)
        }
    }
    
    public init(store: Store<WorkoutsWithDetailsState, WorkoutsWithDetailsAction>) {
        self.store = store
        self.viewStore = self.store.scope(
            value: { $0.workoutsState },
            action: { .workoutsView($0) }
        )
            .view(removeDuplicates: ==)
    }
}

struct Workouts_Previews: PreviewProvider {
    static var previews: some View {
        Workouts(
            store: .init(
                initialValue: .initial,
                reducer: workoutsWithDetailsReducer,
                environment: .mock
            )
        )
    }
    
    private static let workouts: [Workout] = [
        .init(id: "День груди", name: "День груди"),
        .init(id: "День ног", name: "День ног"),
        .init(id: "День плеч", name: "День плеч")
    ]
}
