//
//  File.swift
//  
//
//  Created by Jason Dubon on 4/18/23.
//

import UIKit


public protocol SignInKitDelegate: AnyObject {
    func didTapSignInApple()
    func didTapSignInGoogle()
}

public class SignInKit {
    
    private let signInPage: SignInPage
    
    private var rootVC: UIViewController?
    
    public weak var delegate: SignInKitDelegate?
    
    
    private lazy var signInViewController: SignInViewController = {
        let controller = SignInViewController(signInPage: signInPage, buttons: [.apple, .google])
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.didTapAppleSignIn = { [weak self] in
            self?.delegate?.didTapSignInApple()
        }
        controller.didTapGoogleSignIn = { [weak self] in
            self?.delegate?.didTapSignInGoogle()
        }
        return controller
    }()
    
    
    public init(signInPage: SignInPage) {
        self.signInPage = signInPage
    }
    
    public func lauanchSignIn(rootVC: UIViewController) {
        self.rootVC = rootVC
        rootVC.present(signInViewController, animated: true)
    }
    
    public func dismissSignIn() {
        if rootVC?.presentedViewController == signInViewController {
            signInViewController.dismiss(animated: true)
        }
    }
}
