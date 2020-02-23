//
//  ForgotPassword.swift
//  nomasi
//
//  Created by Alexander Krupichko on 25.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

struct ForgotPassword: View {
    @ObservedObject var store: Store<AuthorizationState, AuthorizationAction>
    public var body: some View {
        ScrollView() {
            Spacer(minLength: .gridSteps(4))
            VStack() {
                NOTextField(L10n.Authorization.Placeholder.email, text: email)
                    .keyboardType(.emailAddress)
                    .disabled(self.store.value.loading)
            }
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            Spacer(minLength: .gridSteps(20))
            NOWideTextButton(L10n.Authorization.RestorePassword.Button.title) {
                self.store.send(.resetTapped(L10n.Authorization.ForgotPassword.Reset.Alert.Confirm.message))
            }
            .disabled(self.store.value.loading)
            Spacer(minLength: .gridSteps(4))
            NOWideTextButton(L10n.Authorization.Auth.Button.title) {
                self.store.send(.present(.authorization))
            }
            .disabled(self.store.value.loading)
        }
        .navigationBarTitle(Text(L10n.Authorization.ForgotPassword.title), displayMode: .inline)
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onDisappear() { self.store.send(.closed(.forgotPassword)) }
        .alert(item: .constant(self.store.value.alert)) { alert in
            switch alert.style {
            case let .info(message):
                return Alert(title: Text(message),
                             dismissButton: .default(Text("Ok")) { self.store.send(.alertDidHide) })
            case let .dismissAction(message, dismissAction):
                return Alert(title: Text(message),
                             dismissButton: .default(Text("Ok")){ self.store.send(dismissAction) })
            case let .action(message, action):
                return Alert(title: Text(message), message: nil,
                             primaryButton: .default(.init("Ok"), action: { self.store.send(action) }),
                             secondaryButton: .cancel({ self.store.send(.alertDidHide) }))
            }
        }
    }
    
    public init(store: Store<AuthorizationState, AuthorizationAction>) {
        self.store = store
    }
}

extension ForgotPassword {
    var email: Binding<String> { .init(get: { self.store.value.email ?? "" },
                                       set: { self.store.send(.emailChanged($0)) }) }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(store: .init(initialValue: .init(presented: .none,
                                                        loading: false,
                                                        email: "email@email.ru",
                                                        password: "some pass",
                                                        confirmPassword: "some pass"),
                                    reducer: authorizationReducer))
    }
}
