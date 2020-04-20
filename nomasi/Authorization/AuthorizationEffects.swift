//
//  AuthorizationEffects.swift
//  nomasi
//
//  Created by Alexander Krupichko on 12.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//
import AuthenticationServices
import ComposableArchitecture
import Combine
import FirebaseAuth

enum AuthorizationEffects {
    static var authErrorConverter: (NSError) -> AuthorizationError {
        return { error in
            guard let message = error.userInfo["NSLocalizedDescription"] as? String
                else { return .message(L10n.Authorization.Error.undefined) }
            return .message(message)
        }
    }
    
    static func appleSignIn(start: @escaping (@escaping ApplePayAuthResult) -> Void) -> () -> Effect<AuthorizationAction> {
        return {
            return Future<AuthorizationAction,NSError>.init { callback in
                start() {
                    if let appleIDCredential = $0?.credential as? ASAuthorizationAppleIDCredential {
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            print("Unable to fetch identity token")
                            callback(.failure(NSError()))
                            return
                        }
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            callback(.failure(NSError()))
                            return
                        }
                        // Initialize a Firebase credential.
                        let credential = OAuthProvider.credential(
                            withProviderID: "apple.com",
                            idToken: idTokenString,
                            rawNonce: nil
                        )
                        // Sign in with Firebase.
                        Auth.auth().signIn(with: credential) {
                            if $0 != nil {
                                callback(
                                    Result<AuthorizationAction, NSError>.success(
                                        .success(
                                            message: L10n.Authorization.AppleSignIn.Success.message
                                        )
                                    )
                                )
                            } else if let error: NSError = $1 as NSError? {
                                callback(.failure(error))
                            } else {
                                callback(.failure(NSError()))
                            }
                        }
                    } else {
                        callback(.failure(NSError()))
                    }
                }
            }
            .catch { Just(.error(authErrorConverter($0))) }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        }
    }
}

enum AuthorizationError: Error, Equatable {
    case message(String)
}
