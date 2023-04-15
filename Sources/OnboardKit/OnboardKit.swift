import UIKit

public protocol OnboardKitDelegate: AnyObject {
    func nextButtonDidTap(index: Int)
    func getStartedButtonDidTap()
}

public protocol OnboardKitSignInDelegate: AnyObject {
    func didTapSignInApple()
    func didTapSignInGoogle()
}

enum OnboardInitializationType {
    case onboard
    case signIn
    case onboardAndSignIn
}

public class OnboardKit {
    
    private let onboardInitializationType: OnboardInitializationType
    
    private let onboardSlides: [Slide]
    private let onboardTintColor: UIColor
    private let signInPage: SignInPage
    
    private var rootVC: UIViewController?
    
    public weak var onboardDelegate: OnboardKitDelegate?
    public weak var signInDelegate: OnboardKitSignInDelegate?
    
    private lazy var onboardingViewController: OnboardViewController = {
        let controller = OnboardViewController(slides: onboardSlides, tintColor: onboardTintColor)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.nextButtonDidTap = { [weak self] index in
            self?.onboardDelegate?.nextButtonDidTap(index: index)
        }
        controller.getStartedButtonDidTap = { [weak self] in
            self?.onboardDelegate?.getStartedButtonDidTap()
        }
        return controller
    }()
    
    private lazy var signInViewController: SignInViewController = {
        let controller = SignInViewController(signInPage: signInPage, buttons: [.apple, .google])
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        controller.didTapAppleSignIn = { [weak self] in
            self?.signInDelegate?.didTapSignInApple()
        }
        controller.didTapGoogleSignIn = { [weak self] in
            self?.signInDelegate?.didTapSignInGoogle()
        }
        return controller
    }()
    
    public init(onboardSlides: [Slide], onboardTintColor: UIColor, signInPage: SignInPage) {
        self.onboardInitializationType = .onboardAndSignIn
        self.onboardSlides = onboardSlides
        self.onboardTintColor = onboardTintColor
        self.signInPage = signInPage
    }
    
    public init(onboardSlides: [Slide], onboardTintColor: UIColor) {
        self.onboardInitializationType = .onboard
        self.onboardSlides = onboardSlides
        self.onboardTintColor = onboardTintColor
        self.signInPage = SignInPage(image: UIImage(), title: "")
        
    }
    
    public init(signInPage: SignInPage) {
        self.onboardInitializationType = .signIn
        self.signInPage = signInPage
        self.onboardSlides = [Slide]()
        self.onboardTintColor = .systemBackground
    }
    
    public func launchOnboardingWithSignIn(rootVC: UIViewController) {
        if onboardInitializationType == .onboardAndSignIn {
            self.rootVC = rootVC
            rootVC.present(signInViewController, animated: true)
            signInViewController.present(onboardingViewController, animated: false)
        } else {
            print("ERROR: Please initialize the OnboardKit with the correct properties to use this function.")
        }
    }
    
    public func launchOnboarding(rootVC: UIViewController) {
        if onboardInitializationType == .onboard {
            self.rootVC = rootVC
            rootVC.present(onboardingViewController, animated: true)
        } else {
            print("ERROR: Please initialize the OnboardKit with the correct properties to use this function.")
        }
    }
    
    public func lauanchSignIn(rootVC: UIViewController) {
        if onboardInitializationType == .onboard {
            self.rootVC = rootVC
            rootVC.present(signInViewController, animated: true)
        } else {
            print("ERROR: Please initialize the OnboardKit with the correct properties to use this function.")
        }
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
