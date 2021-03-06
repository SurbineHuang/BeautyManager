//
//  SignInViewController.swift
//  BeautyManager
//
//  Created by SurbineHuang on 31/5/21.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signInWithAppleButtonView: UIView!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupProviderLoginView()
        
        if UIDevice.isSimulator {
            self.skipButton.isHidden = false
            // 直接存一組 AppleId 到 UserDefault
            userDefaults.set("000621.496f586135014afa92ac6a2c38b3fd53.1518", forKey: "appleId")
        } else {
            self.skipButton.isHidden = true
        }
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupProviderLoginView() {

        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.signInWithAppleButtonView.addSubview(authorizationButton)
        NSLayoutConstraint.activate([
            authorizationButton.heightAnchor.constraint(equalToConstant: 45),
            authorizationButton.widthAnchor.constraint(equalToConstant: 280),
            authorizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorizationButton.bottomAnchor.constraint(equalTo: privacyButton.topAnchor, constant: -20)
        ])
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

extension SignInViewController: ASAuthorizationControllerDelegate {
    
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
                
                userDefaults.set(appleIDCredential.user, forKey: "appleId")
                
                ProductManager.shared.addUser(appleId: appleIDCredential.user)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        /// 授權失敗
        /// - Parameters:
        ///   - controller: _
        ///   - error: _
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
                    
            switch error {
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

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    
    func showSignInViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)// 生成要切換的 storyboard
        if let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
            signInViewController.modalPresentationStyle = .fullScreen
            signInViewController.isModalInPresentation = true
            self.present(signInViewController, animated: true, completion: nil)
        }
    }
}
