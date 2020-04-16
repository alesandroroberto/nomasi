//
//  ExerciseDetails.swift
//  NOExercises
//
//  Created by Alexander Krupichko on 15.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import DesignKit
import SwiftUI

public struct ExerciseDetails: View {
    let store: Store<ExerciseDetailsState, ExerciseDetailsAction>
    @ObservedObject var viewStore: ViewStore<ExerciseDetailsState, ExerciseDetailsAction>
    public var body: some View {
        ScrollView() {
            Spacer(minLength: .gridSteps(4))
            VStack() {
                Text(self.viewStore.value.exercise?.name ?? "Exercise")
                    .font(.title)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .gridSteps(4))
                    .padding(.vertical, .gridSteps(2))
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            .padding(.horizontal, .gridSteps(4))
            Spacer(minLength: .gridSteps(4))
            VStack() {
                Text(self.viewStore.value.exercise?.description ?? "Description")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .gridSteps(4))
                    .padding(.vertical, .gridSteps(2))
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            .padding(.horizontal, .gridSteps(4))
        }
        .navigationBarTitle(viewStore.value.exercise?.name ?? "")
        .onAppear(perform: { self.viewStore.send(.viewDidLoad); print("ExerciseDetails appear") })
        .onDisappear(perform: { self.viewStore.send(.disappeared); print("ExerciseDetails Disappear") })
    }
    
    public init(store: Store<ExerciseDetailsState, ExerciseDetailsAction>) {
        self.store = store
        self.viewStore = self.store.view(removeDuplicates: ==)
    }
}

struct ExerciseDetails_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetails(store: .init(
            initialValue: .initial,
            reducer: exerciseDetailsReducer,
            environment: ExerciseDetailsEnvironment()
            )
        )
    }
}