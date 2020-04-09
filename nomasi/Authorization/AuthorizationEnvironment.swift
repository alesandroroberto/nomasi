//
//  AuthorizationEnvironment.swift
//  nomasi
//
//  Created by Alexander Krupichko on 19.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import Combine
import ComposableArchitecture
import FirebaseAuth

struct AuthorizationEnvironment {
    typealias Email = String
    typealias Password = String
    
    var emptyCredentials: () -> Effect<AuthorizationAction>
    var emptyEmail: () -> Effect<AuthorizationAction>
    var emptyRegisterCredentials: () -> Effect<AuthorizationAction>
    var passwordConfirmationError: () -> Effect<AuthorizationAction>
    var authorization: (Email, Password) -> Effect<AuthorizationAction>
    var resetPassword: (Email) -> Effect<AuthorizationAction>
    var registration: (Email, Password) -> Effect<AuthorizationAction>
    var appleSignIn: () -> Effect<AuthorizationAction>
}

extension AuthorizationEnvironment {
    static func live(startAppleSignIn: @escaping (@escaping ApplePayAuthResult) -> Void) -> AuthorizationEnvironment {
        AuthorizationEnvironment(
            emptyCredentials: { AuthorizationEffects.emptyCredentials },
            emptyEmail: { AuthorizationEffects.emptyEmail },
            emptyRegisterCredentials: { AuthorizationEffects.emptyRegistrationCredentials },
            passwordConfirmationError: { AuthorizationEffects.passwordConfirmationError },
            authorization: AuthorizationEffects.authorize,
            resetPassword: AuthorizationEffects.resetPassword,
            registration: AuthorizationEffects.registraion,
            appleSignIn: AuthorizationEffects.appleSignIn(start: startAppleSignIn)
        )
    }
}
