//
//  Authorization.swift
//  Authorization
//
//  Created by Alexander Krupichko on 11.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

struct Authorization: View {
    let store: Store<AuthorizationState, AuthorizationAction>
    @ObservedObject var viewStore: ViewStore<AuthorizationState, AuthorizationAction>
    
    public init(store: Store<AuthorizationState, AuthorizationAction>) {
      self.store = store
      self.viewStore = self.store.view(removeDuplicates: ==)
    }
    
    public var body: some View {
        ScrollView() {
            Spacer(minLength: .gridSteps(4))
            VStack() {
                NOTextField(L10n.Authorization.Placeholder.email, text: email)
                    .keyboardType(.emailAddress)
                    .disabled(self.viewStore.value.loading)
                Divider()
                NOSecureField(L10n.Authorization.Placeholder.password, text: password)
                    .disabled(self.viewStore.value.loading)
            }
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            Spacer(minLength: .gridSteps(20))
            NOWideTextButton(L10n.Authorization.Auth.Button.title) { self.viewStore.send(.authorizationTapped) }
                .disabled(self.viewStore.value.loading)
            Spacer(minLength: .gridSteps(4))
            NOWideTextButton(L10n.Authorization.RestorePassword.Button.title) { self.viewStore.send(.present(.forgotPassword)) }
                .disabled(self.viewStore.value.loading)
            Spacer(minLength: .gridSteps(4))
            NOWideTextButton("Apple SignIn") { self.viewStore.send(.signInWithAppleTapped) }
                .disabled(self.viewStore.value.loading)
        }
        .navigationBarTitle(Text(L10n.Authorization.Auth.title), displayMode: .inline)
        .padding(.horizontal, .gridSteps(4))
        .onDisappear() { self.viewStore.send(.closed(.authorization)) }
        .alert(item: .constant(self.viewStore.value.alert)) { alert in
            Alert(
                title: Text(alert.style.message),
                dismissButton: .default(Text("Ok")) {
                    self.viewStore.send(.alertDidHide)
                }
            )
        }
    }
}

extension Authorization {
    var email: Binding<String> { .init(get: { self.viewStore.value.email ?? "" },
                                       set: { self.viewStore.send(.emailChanged($0)) }) }
    var password: Binding<String> { .init(get: { self.viewStore.value.password ?? "" },
                                          set: { self.viewStore.send(.passwordChanged($0)) }) }
}
