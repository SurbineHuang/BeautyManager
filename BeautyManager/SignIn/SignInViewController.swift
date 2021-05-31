//
//  SignInViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 31/5/21.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInWithAppleButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupProviderLoginView()
    }
    
    func setupProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.signInWithAppleButtonView.addSubview(authorizationButton)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    /// 授權成功
        /// - Parameters:
        ///   - controller: _
        ///   - authorization: _
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
                    
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                print("user: \(appleIDCredential.user)")
                print("fullName: \(String(describing: appleIDCredential.fullName))")
                print("Email: \(String(describing: appleIDCredential.email))")
                print("realUserStatus: \(String(describing: appleIDCredential.realUserStatus))")
            }
        }
        
        /// 授權失敗
        /// - Parameters:
        ///   - controller: _
        ///   - error: _
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
                    
            switch (error) {
            case ASAuthorizationError.canceled:
                break
            case ASAuthorizationError.failed:
                break
            case ASAuthorizationError.invalidResponse:
                break
            case ASAuthorizationError.notHandled:
                break
            case ASAuthorizationError.unknown:
                break
            default:
                break
            }
            print("didCompleteWithError: \(error.localizedDescription)")
        }
}

extension LoginViewController:  ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

//extension LoginViewController: ASAuthorizationControllerDelegate {
//    /// - Tag: did_complete_authorization
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
////            self.saveUserInKeychain(userIdentifier)
//
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
////            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//
//        case let passwordCredential as ASPasswordCredential:
//
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//
//        default:
//            break
//        }
//    }
//
//}
