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

struct AppState: Equatable {
    var authorizationState: AuthorizationState
}

enum AppAction {
    case authorizationView(AuthorizationAction)
    
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

typealias AppEnvironment = AuthorizationEnvironment

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = combine(
    pullback(authorizationReducer,
             value: \AppState.authorizationState,
             action: /AppAction.authorizationView,
             environment: { $0 })
)

struct ContentView: View {
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    
    public init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = self.store.view(removeDuplicates: ==)
    }
    
    var body: some View {
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
    }
}
