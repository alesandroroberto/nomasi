//
//  AuthorizationState.swift
//  nomasi
//
//  Created by Alexander Krupichko on 25.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture

struct AuthorizationState: Equatable {
    public var alert: Alert?
    public var presented: PresentedScreen
    public var loading: Bool
    public var email: String?
    public var password: String?
    public var confirmPassword: String?
    
    public init(alert: Alert? = nil,
                presented: PresentedScreen,
                loading: Bool,
                email: String?,
                password: String?,
                confirmPassword: String?) {
        self.alert = alert
        self.presented = presented
        self.loading = loading
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
    public struct Alert: Equatable, Identifiable {
        public let style: Style
        public var id: Int { self.style.message.hashValue }
        
        public enum Style: Equatable {
            case info(String)
            case dismissAction(String, AuthorizationAction)
            case action(String, AuthorizationAction)
            
            var message: String {
                switch self {
                case let .info(message), let .dismissAction(message, _), let .action(message, _):
                    return message
                }
            }
        }
    }
    
    public enum PresentedScreen: Equatable {
        case authorization
        case registration
        case forgotPassword
        case none
    }
}

enum AuthorizationAction: Equatable {
    case success(message: String)
    case error(AuthorizationError)
    case signInWithAppleTapped
    case alertDidHide
}

func authorizationReducer(
    state: inout AuthorizationState,
    action: AuthorizationAction,
    environment: AuthorizationEnvironment
) -> [Effect<AuthorizationAction>] {
    switch action {
    case .success(let message):
        state.loading = false
        state.alert = .init(style: .info(message))
        return []
    case .error(let error):
        state.loading = false
        switch error {
        case .message(let message):
            state.alert = .init(style: .info(message))
        }
        return []
    case .signInWithAppleTapped:
        state.loading = true
        return [environment.appleSignIn()]
    case .alertDidHide:
        state.alert = nil
        return []
    }
}
