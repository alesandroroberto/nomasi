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
            }
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            Spacer(minLength: .gridSteps(20))
            NOWideTextButton(L10n.Authorization.RestorePassword.Button.title) {
                self.viewStore.send(.resetTapped(L10n.Authorization.ForgotPassword.Reset.Alert.Confirm.message))
            }
            .disabled(self.viewStore.value.loading)
            Spacer(minLength: .gridSteps(4))
            NOWideTextButton(L10n.Authorization.Auth.Button.title) {
                self.viewStore.send(.present(.authorization))
            }
            .disabled(self.viewStore.value.loading)
        }
        .navigationBarTitle(Text(L10n.Authorization.ForgotPassword.title), displayMode: .inline)
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onDisappear() { self.viewStore.send(.closed(.forgotPassword)) }
        .alert(item: .constant(self.viewStore.value.alert)) { alert in
            switch alert.style {
            case let .info(message):
                return Alert(title: Text(message),
                             dismissButton: .default(Text("Ok")) { self.viewStore.send(.alertDidHide) })
            case let .dismissAction(message, dismissAction):
                return Alert(title: Text(message),
                             dismissButton: .default(Text("Ok")){ self.viewStore.send(dismissAction) })
            case let .action(message, action):
                return Alert(title: Text(message), message: nil,
                             primaryButton: .default(.init("Ok"), action: { self.viewStore.send(action) }),
                             secondaryButton: .cancel({ self.viewStore.send(.alertDidHide) }))
            }
        }
    }
}

extension ForgotPassword {
    var email: Binding<String> { .init(get: { self.viewStore.value.email ?? "" },
                                       set: { self.viewStore.send(.emailChanged($0)) }) }
}
