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
    case success
    case error(AuthorizationError)
    case emailChanged(String)
    case passwordChanged(String)
    case confirmPasswordChanged(String)
    case signInWithAppleTapped
    case authorizationTapped
    case registrarionTapped
    case resetTapped(String)
    case resetConfirm
    case resetPasswordSuccess(String)
    case alertDidHide
    case present(AuthorizationState.PresentedScreen)
    case closed(AuthorizationState.PresentedScreen)
}

func authorizationReducer(
    state: inout AuthorizationState,
    action: AuthorizationAction,
    environment: AuthorizationEnvironment
) -> [Effect<AuthorizationAction>] {
    switch action {
    case .success:
        state.loading = false
        let presented = state.presented
        return [.sync(work: { .closed(presented) })]
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
    case .authorizationTapped:
        guard let email = state.email, let password = state.password else { return [environment.emptyCredentials()] }
        state.loading = true
        return [environment.authorization(email, password)]
    case .registrarionTapped:
        guard let email = state.email, let password = state.password, state.confirmPassword != nil
            else { return [environment.emptyRegisterCredentials()] }
        guard state.confirmPassword == password
            else { return [environment.passwordConfirmationError()] }
        state.loading = true
        return [environment.registration(email, password)]
    case .resetConfirm:
        state.alert = nil
        guard let email = state.email else { return [environment.emptyEmail()] }
        state.loading = true
        return [environment.resetPassword(email)]
    case .resetTapped(let message):
        state.alert = .init(style: .action(message, .resetConfirm))
        return []
    case .resetPasswordSuccess(let message):
        state.loading = false
        state.alert = .init(style: .dismissAction(message, .present(.authorization)))
        return []
    case .emailChanged(let value):
        state.email = value.isEmpty ? nil : value
        return []
    case .passwordChanged(let value):
        state.password = value.isEmpty ? nil : value
        return []
    case .confirmPasswordChanged(let value):
        state.confirmPassword = value.isEmpty ? nil : value
        return []
    case .alertDidHide:
        state.alert = nil
        return []
    case .present(let screen):
        state.alert = nil
        state.presented = screen
        return []
    case .closed(let screen):
        if screen == state.presented {
            state.presented = .none
        }
        return []
    }
}
