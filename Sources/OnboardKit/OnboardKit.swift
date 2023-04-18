import UIKit

public protocol OnboardKitDelegate: AnyObject {
    func nextButtonDidTap(index: Int)
    func getStartedButtonDidTap()
}

public class OnboardKit {
    
    private let onboardSlides: [Slide]
    private let onboardTintColor: UIColor
    private let signInPage: SignInPage
    
    private var rootVC: UIViewController?
    
    public weak var delegate: OnboardKitDelegate?
    
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
    
    public init(onboardSlides: [Slide], onboardTintColor: UIColor) {
        self.onboardSlides = onboardSlides
        self.onboardTintColor = onboardTintColor
        self.signInPage = SignInPage(image: UIImage(), title: "")
        
    }
    
    public func launchOnboarding(rootVC: UIViewController) {
        self.rootVC = rootVC
        rootVC.present(onboardingViewController, animated: true)
    }
    
    public func dismissOnboarding() {
        onboardingViewController.stopAnimation()
        if rootVC?.presentedViewController == onboardingViewController {
            onboardingViewController.dismiss(animated: true)
        }
    }
}
