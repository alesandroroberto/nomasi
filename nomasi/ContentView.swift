//
//  ContentView.swift
//  nomasi
//
//  Created by Alexander Krupichko on 11.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//
import CasePaths
import Combine
import ComposableArchitecture
import SwiftUI
import DesignKit
import NOExercises
import NOWorkout

struct AppState: Equatable {
    var authorizationState: AuthorizationState
    var exercisesGroupsWithExercisesState: ExercisesGroupsWithExercisesState
    var workoutsWithDetailsState: WorkoutsWithDetailsState
}

enum AppAction {
    case authorizationView(AuthorizationAction)
    case exercisesGroupsWithExercisesView(ExercisesGroupsWithExercisesAction)
    case workoutsWithDetailsView(WorkoutsWithDetailsAction)
}

extension AppState {
    var authorizationView: AuthorizationState {
        get {
            AuthorizationState(alert: authorizationState.alert,
                               presented: authorizationState.presented,
                               loading: authorizationState.loading,
                               email: authorizationState.email,
                               password: authorizationState.password,
                               confirmPassword: authorizationState.confirmPassword)
        }
        set {
            self.authorizationState.alert = newValue.alert
            self.authorizationState.presented = newValue.presented
            self.authorizationState.loading = newValue.loading
            self.authorizationState.email = newValue.email
            self.authorizationState.password = newValue.password
            self.authorizationState.confirmPassword = newValue.confirmPassword
        }
    }
}

struct AppEnvironment {
    let authorizationEnvironment: AuthorizationEnvironment
    let exercisesGroupsWithExercisesEnvironment: ExercisesGroupsWithExercisesEnvironment
    let workoutsWithDetailsEnvironment: WorkoutsWithDetailsEnvironment
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
    pullback(authorizationReducer,
             value: \AppState.authorizationState,
             action: /AppAction.authorizationView,
             environment: { $0.authorizationEnvironment }),
    pullback(groupsWithExercisesReducer(groupsReducer),
             value: \AppState.exercisesGroupsWithExercisesState,
             action: /AppAction.exercisesGroupsWithExercisesView,
             environment: { $0.exercisesGroupsWithExercisesEnvironment }),
    pullback(workoutsWithDetailsConnectReducer(workoutsWithDetailsReducer),
             value: \AppState.workoutsWithDetailsState,
             action: /AppAction.workoutsWithDetailsView,
             environment: { $0.workoutsWithDetailsEnvironment })
)

struct ContentView: View {
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    
    public init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = self.store.view(removeDuplicates: ==)
    }
    
    var body: some View {
        TabView {
            Workouts(store: self.store.scope(
                value: { $0.workoutsWithDetailsState },
                action: { .workoutsWithDetailsView($0) })
            ).tabItem {
                Image(systemName: "1.square.fill")
                Text("First")
            }
            ExerciseGroups(store: self.store.scope(
                value: { $0.exercisesGroupsWithExercisesState },
                action: { .exercisesGroupsWithExercisesView($0) })
            ).tabItem {
                Image(systemName: "2.square.fill")
                Text("Second")
            }
            NavigationView {
                ScrollView() {
                    Text(self.viewStore.value.authorizationState.presented == .none ? "false" : "true")
                    NOWideTextButton("Show auth") { self.viewStore.send(.authorizationView(.present(.authorization))) }
                        .disabled(self.viewStore.value.authorizationState.presented != .none)
                    Spacer()
                    NOWideTextButton("Register") { self.viewStore.send(.authorizationView(.present(.registration))) }
                        .disabled(self.viewStore.value.authorizationState.presented != .none)
                    Spacer()
                    NavigationLink(destination: Authorization(
                        store: self.store.scope(
                            value: { $0.authorizationView },
                            action: { .authorizationView($0) }
                        )
                    ), isActive: .constant(self.viewStore.value.authorizationState.presented == .authorization)) {
                        EmptyView()
                    }
                    NavigationLink(destination: ForgotPassword(
                        store: self.store.scope(
                            value: { $0.authorizationView },
                            action: { .authorizationView($0) }
                        )
                    ), isActive: .constant(self.viewStore.value.authorizationState.presented == .forgotPassword)) {
                        EmptyView()
                    }
                    NavigationLink(destination: Registration(
                        store: self.store.scope(
                            value: { $0.authorizationView },
                            action: { .authorizationView($0) }
                        )
                    ), isActive: .constant(self.viewStore.value.authorizationState.presented == .registration)) {
                        EmptyView()
                    }
                }
                .navigationBarTitle("Nomasi")
                .padding(.horizontal, .gridSteps(4))
            }
            .tabItem {
                Image(systemName: "3.square.fill")
                Text("Third")
            }
        }
    }
}
