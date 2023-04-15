//
//  SignInViewController 2.swift
//
//
//  Created by Jason Dubon on 4/14/23.
//

import UIKit

class SignInViewController: UIViewController {

    var didTapAppleSignIn: (() -> Void)?
    var didTapGoogleSignIn: (() -> Void)?
    var didTapTermsService: (() -> Void)?
    var didTapPrivacyPolicy: (() -> Void)?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = signInPage.image
        
        return view
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = signInPage.title
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .thin)
        label.textColor = .black
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var buttonViews: [CustomButtonView] = {
        var views = [CustomButtonView]()
        views = buttons.compactMap({CustomButtonView(buttonLogo: $0)})
        
        return views
    }()
    
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: buttonViews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 12
        view.distribution = .fillEqually
        view.axis = .vertical
        
        return view
    }()
    
    private lazy var termsAndConditionsView: TermsAndCondititonsView = {
        let view = TermsAndCondititonsView()
        view.didTapTermsService = { [weak self] in
            self?.didTapTermsService?()
        }
        view.didTapPrivacyPolicy = { [weak self] in
            self?.didTapPrivacyPolicy?()
        }
        
        return view
    }()
    
    private let buttons: [SignInButton]
    private let signInPage: SignInPage
    init(signInPage: SignInPage, buttons: [SignInButton]) {
        self.buttons = buttons
        self.signInPage = signInPage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        setupCustomButtons()
    }
    

    private func configureUI() {
        view.addSubview(imageView)
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(termsAndConditionsView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            welcomeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 80),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            stackView.heightAnchor.constraint(equalToConstant: CGFloat(70*buttons.count)),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            
            termsAndConditionsView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            termsAndConditionsView.heightAnchor.constraint(equalToConstant: 60),
            termsAndConditionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            termsAndConditionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
        ])
    }
    
    private func setupCustomButtons() {
        for buttonView in buttonViews {
            buttonView.didTapButton = { [weak self] button in
                guard let strongSelf = self else { return }
                switch button {
                case .apple:
                    strongSelf.didTapApple()
                case .google:
                    strongSelf.didTapGoogle()
                }
            }
        }
    }
    
    private func didTapApple() {
        didTapAppleSignIn?()
    }
    
    private func didTapGoogle() {
        didTapGoogleSignIn?()
    }
    
}

