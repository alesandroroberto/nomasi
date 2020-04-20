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
    var appleSignIn: () -> Effect<AuthorizationAction>
}

extension AuthorizationEnvironment {
    static func live(startAppleSignIn: @escaping (@escaping ApplePayAuthResult) -> Void) -> AuthorizationEnvironment {
        AuthorizationEnvironment(
            appleSignIn: AuthorizationEffects.appleSignIn(start: startAppleSignIn)
        )
    }
}
