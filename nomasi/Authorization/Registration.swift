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
                Divider()
                NOSecureField(L10n.Authorization.Placeholder.confirmPassword, text: confirmPassword)
                .disabled(self.store.value.loading)
            }
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(.gridSteps(4))
            Spacer(minLength: .gridSteps(20))
            NOWideTextButton(L10n.Authorization.Registration.Button.title) { self.store.send(.registrarionTapped) }
                .disabled(self.store.value.loading)
            Spacer(minLength: .gridSteps(4))
            NOWideTextButton(L10n.Authorization.Registration.AuthButton.title) { self.store.send(.present(.authorization)) }
                .disabled(self.store.value.loading)
        }
        .navigationBarTitle(Text(L10n.Authorization.Registration.title), displayMode: .inline)
        .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onDisappear() { self.store.send(.closed(.registration)) }
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

extension Registration {
    var email: Binding<String> { .init(get: { self.store.value.email ?? "" },
                                       set: { self.store.send(.emailChanged($0)) }) }
    var password: Binding<String> { .init(get: { self.store.value.password ?? "" },
                                          set: { self.store.send(.passwordChanged($0)) }) }
    var confirmPassword: Binding<String> { .init(get: { self.store.value.confirmPassword ?? "" },
                                                 set: { self.store.send(.confirmPasswordChanged($0)) }) }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Authorization(store: .init(initialValue: .init(presented: .none,
                                                       loading: false,
                                                       email: "email@email.ru",
                                                       password: "some pass",
                                                       confirmPassword: "some pass"),
                                   reducer: authorizationReducer))
    }
}
