//
//  ContentView.swift
//  nomasi
//
//  Created by Alexander Krupichko on 11.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//
import Combine
import ComposableArchitecture
import SwiftUI
import DesignKit

struct AppState {
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

let appReducer = combine(
    pullback(authorizationReducer, value: \AppState.authorizationState, action: \AppAction.authorizationView)
)

struct ContentView: View {
    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            ScrollView() {
                Text(self.store.value.authorizationState.presented == .none ? "false" : "true")
                NOWideTextButton("Show auth") { self.store.send(.authorizationView(.present(.authorization))) }
                    .disabled(self.store.value.authorizationState.presented != .none)
                Spacer()
                NOWideTextButton("Register") { self.store.send(.authorizationView(.present(.registration))) }
                    .disabled(self.store.value.authorizationState.presented != .none)
                Spacer()
                NavigationLink(destination: Authorization(
                    store: self.store.view(
                        value: { $0.authorizationView },
                        action: { .authorizationView($0) }
                    )
                ), isActive: .constant(self.store.value.authorizationState.presented == .authorization)) {
                    EmptyView()
                }
                NavigationLink(destination: ForgotPassword(
                    store: self.store.view(
                        value: { $0.authorizationView },
                        action: { .authorizationView($0) }
                    )
                ), isActive: .constant(self.store.value.authorizationState.presented == .forgotPassword)) {
                    EmptyView()
                }
                NavigationLink(destination: Registration(
                    store: self.store.view(
                        value: { $0.authorizationView },
                        action: { .authorizationView($0) }
                    )
                ), isActive: .constant(self.store.value.authorizationState.presented == .registration)) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Nomasi")
            .padding(.horizontal, .gridSteps(4))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .init(initialValue: .init(
            authorizationState: .init(presented: .none,
                                      loading: false,
                                      email: nil,
                                      password: nil,
                                      confirmPassword: nil)),
                                 reducer: appReducer
            ))
    }
}
