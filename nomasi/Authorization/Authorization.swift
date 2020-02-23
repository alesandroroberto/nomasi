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
    @ObservedObject var store: Store<AuthorizationState, AuthorizationAction>
    public var body: some View {
        ScrollView() {
            Spacer(minLength: .gridSteps(4))
            VStack() {
                NOTextField(L10n.Authorization.Placeholder.email, text: email)
                    .keyboardType(.emailAddress)
                    .disabled(self.store.value.loading)
                Divider()
                NOSecureField(L10n.Authorization.Placeholder.password, text: password)
                    .disabled(self.store.value.loading)
            }
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            Spacer(minLength: .gridSteps(20))
            NOWideTextButton(L10n.Authorization.Auth.Button.title) { self.store.send(.authorizationTapped) }
                .disabled(self.store.value.loading)
            Spacer(minLength: .gridSteps(4))
            NOWideTextButton(L10n.Authorization.RestorePassword.Button.title) { self.store.send(.present(.forgotPassword)) }
                .disabled(self.store.value.loading)
        }
        .navigationBarTitle(Text(L10n.Authorization.Auth.title), displayMode: .inline)
        .padding(.horizontal, .gridSteps(4))
        .onDisappear() { self.store.send(.closed(.authorization)) }
        .alert(item: .constant(self.store.value.alert)) { alert in
            Alert(
                title: Text(alert.style.message),
                dismissButton: .default(Text("Ok")) {
                    self.store.send(.alertDidHide)
                }
            )
        }
    }
    
    public init(store: Store<AuthorizationState, AuthorizationAction>) {
        self.store = store
    }
}

extension Authorization {
    var email: Binding<String> { .init(get: { self.store.value.email ?? "" },
                                       set: { self.store.send(.emailChanged($0)) }) }
    var password: Binding<String> { .init(get: { self.store.value.password ?? "" },
                                          set: { self.store.send(.passwordChanged($0)) }) }
}

struct Authorization_Previews: PreviewProvider {
    static var previews: some View {
        Authorization(store: .init(initialValue: .init(presented: .none,
                                                       loading: false,
                                                       email: "email@email.ru",
                                                       password: "some pass",
                                                       confirmPassword: "some pass"),
                                   reducer: authorizationReducer))
    }
}
