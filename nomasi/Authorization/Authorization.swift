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
            NOWideTextButton("Apple SignIn") { self.viewStore.send(.signInWithAppleTapped) }
                .disabled(self.viewStore.value.loading)
        }
        .navigationBarTitle(L10n.Authorization.Auth.title)
        .padding(.horizontal, .gridSteps(4))
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
