//
//  Registration.swift
//  nomasi
//
//  Created by Alexander Krupichko on 26.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

struct Registration: View {
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
                Divider()
                NOSecureField(L10n.Authorization.Placeholder.confirmPassword, text: confirmPassword)
                .disabled(self.viewStore.value.loading)
            }
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            Spacer(minLength: .gridSteps(20))
            NOWideTextButton(L10n.Authorization.Registration.Button.title) { self.viewStore.send(.registrarionTapped) }
                .disabled(self.viewStore.value.loading)
            Spacer(minLength: .gridSteps(4))
            NOWideTextButton(L10n.Authorization.Registration.AuthButton.title) { self.viewStore.send(.present(.authorization)) }
                .disabled(self.viewStore.value.loading)
        }
        .navigationBarTitle(Text(L10n.Authorization.Registration.title), displayMode: .inline)
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onDisappear() { self.viewStore.send(.closed(.registration)) }
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

extension Registration {
    var email: Binding<String> { .init(get: { self.viewStore.value.email ?? "" },
                                       set: { self.viewStore.send(.emailChanged($0)) }) }
    var password: Binding<String> { .init(get: { self.viewStore.value.password ?? "" },
                                          set: { self.viewStore.send(.passwordChanged($0)) }) }
    var confirmPassword: Binding<String> { .init(get: { self.viewStore.value.confirmPassword ?? "" },
                                                 set: { self.viewStore.send(.confirmPasswordChanged($0)) }) }
}
