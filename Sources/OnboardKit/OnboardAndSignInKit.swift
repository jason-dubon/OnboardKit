//
//  File.swift
//  
//
//  Created by Jason Dubon on 4/18/23.
//

import UIKit

public protocol OnboardAndSignInKitSignInDelegate: AnyObject {
    func nextButtonDidTap(index: Int)
    func getStartedButtonDidTap()
    func didTapSignInApple()
    func didTapSignInGoogle()
}

public class OnboardAndSignInKit {
    
    private let onboardSlides: [Slide]
    private let onboardTintColor: UIColor
    private let signInPage: SignInPage
    
    private var rootVC: UIViewController?
    
    public weak var delegate: OnboardAndSignInKitSignInDelegate?
    
    private lazy var onboardingViewController: OnboardViewController = {
        let controller = OnboardViewController(slides: onboardSlides, tintColor: onboardTintColor)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.nextButtonDidTap = { [weak self] index in
            self?.delegate?.nextButtonDidTap(index: index)
        }
        controller.getStartedButtonDidTap = { [weak self] in
            self?.delegate?.getStartedButtonDidTap()
        }
        return controller
    }()
    
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
    
    public init(onboardSlides: [Slide], onboardTintColor: UIColor, signInPage: SignInPage) {
        self.onboardSlides = onboardSlides
        self.onboardTintColor = onboardTintColor
        self.signInPage = signInPage
    }
    
    public func launchOnboardingWithSignIn(rootVC: UIViewController) {
        self.rootVC = rootVC
        rootVC.present(signInViewController, animated: true)
        signInViewController.present(onboardingViewController, animated: false)
    }
    
    public func dismissOnboarding() {
        onboardingViewController.stopAnimation()
        if rootVC?.presentedViewController == onboardingViewController {
            onboardingViewController.dismiss(animated: true)
        } else if signInViewController.presentedViewController == onboardingViewController {
            onboardingViewController.dismiss(animated: true)
        }
    }
    
    public func dismissSignIn() {
        if rootVC?.presentedViewController == signInViewController {
            signInViewController.dismiss(animated: true)
        }
    }
}

