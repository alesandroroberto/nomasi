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

struct AppState: Equatable {
    var authorizationState: AuthorizationState
    var exerciseGroupsState: ExerciseGroupsState
    var exercisesState: ExercisesState
}

enum AppAction {
    case authorizationView(AuthorizationAction)
    case exerciseGroupsView(ExerciseGroupsAction)
    case exercisesView(ExercisesAction)
    
    var authorizationView: AuthorizationAction? {
        get {
            guard case let .authorizationView(value) = self else { return nil }
            return value
        }
        set {
            guard case .authorizationView = self, let newValue = newValue else { return }
            self = .authorizationView(newValue)
        }
    }
    var exerciseGroupsView: ExerciseGroupsAction? {
        get {
            guard case let .exerciseGroupsView(value) = self else { return nil }
            return value
        }
        set {
            guard case .exerciseGroupsView = self, let newValue = newValue else { return }
            self = .exerciseGroupsView(newValue)
        }
    }
    var exercisesView: ExercisesAction? {
        get {
            guard case let .exercisesView(value) = self else { return nil }
            return value
        }
        set {
            guard case .exercisesView = self, let newValue = newValue else { return }
            self = .exercisesView(newValue)
        }
    }
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
    var exerciseGroupsView: ExerciseGroupsState {
        get {
            ExerciseGroupsState(groups: exerciseGroupsState.groups,
                                step: exerciseGroupsState.step,
                                selected: exerciseGroupsState.selected)
        }
        set {
            self.exerciseGroupsState.groups = newValue.groups
            self.exerciseGroupsState.step = newValue.step
            self.exerciseGroupsState.selected = newValue.selected
        }
    }
    var exercisesView: ExercisesState {
        get {
            ExercisesState(group: exerciseGroupsState.selected,
                           exercises: exercisesState.exercises,
                           step: exercisesState.step)
        }
        set {
            self.exerciseGroupsState.selected = newValue.group
            self.exercisesState.exercises = newValue.exercises
            self.exercisesState.step = newValue.step
        }
    }
}

struct AppEnvironment {
    let authorizationEnvironment: AuthorizationEnvironment
    let exerciseGroupsEnvironment: ExerciseGroupsEnvironment
    let exercisesEnvironment: ExercisesEnvironment
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
    pullback(authorizationReducer,
             value: \AppState.authorizationState,
             action: /AppAction.authorizationView,
             environment: { $0.authorizationEnvironment }),
    pullback(exerciseGroupsReducer,
             value: \AppState.exerciseGroupsView,
             action: /AppAction.exerciseGroupsView,
             environment: { $0.exerciseGroupsEnvironment }),
    pullback(exercisesReducer,
             value: \AppState.exercisesView,
             action: /AppAction.exercisesView,
             environment: { $0.exercisesEnvironment })
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
            ExerciseGroups(
                store: self.store.scope(
                    value: { $0.exerciseGroupsView },
                    action: { .exerciseGroupsView($0) }
                ),
                exercisesStore: self.store.scope(
                    value: { $0.exercisesView },
                    action: { .exercisesView($0) }
                )
            ).tabItem {
                Image(systemName: "2.square.fill")
                Text("First")
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
                Image(systemName: "1.square.fill")
                Text("Second")
            }
        }
    }
}
