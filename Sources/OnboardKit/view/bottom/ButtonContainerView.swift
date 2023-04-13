//
//  ButtonContainerView.swift
//  
//
//  Created by Jason Dubon on 4/12/23.
//

import UIKit

// We dont want logic in button container view
class ButtonContainerView: UIView {
    
    var nextButtonDidTap: (() -> Void)?
    var getStartedButtonDidTap: (() -> Void)?
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.setTitleColor(viewTintColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.borderColor = viewTintColor.cgColor
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var getStartedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = viewTintColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .init(width: 4, height: 4)
        button.addTarget(self, action: #selector(didTapGetStarted), for: .touchUpInside)
        return button
    }()

    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nextButton, getStartedButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 24
        
        return stackView
    }()
    
    private let viewTintColor: UIColor
    init(tintColor: UIColor) {
        self.viewTintColor = tintColor
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36),
        
            nextButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func didTapNext() {
        nextButtonDidTap?()
    }
    
    @objc private func didTapGetStarted() {
        getStartedButtonDidTap?()
    }
}
