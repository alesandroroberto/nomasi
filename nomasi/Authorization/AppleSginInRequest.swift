//
//  AuthorizationApplePayDelegate.swift
//  nomasi
//
//  Created by Alexander Krupichko on 09.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import AuthenticationServices

typealias ApplePayAuthResult = (ASAuthorization?) -> Void
typealias Nonce = String

class AppleSginInRequest: NSObject {
    private let window: UIWindow
    private var result: ApplePayAuthResult?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func performRequest(result: @escaping ApplePayAuthResult) {
        self.result = result
        // Prepare requests for both Apple ID and password providers.
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleSginInRequest: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        self.result?(authorization)
        self.result = nil
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        self.result?(nil)
        self.result = nil
    }
}

extension AppleSginInRequest: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
}
