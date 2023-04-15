//
//  File.swift
//  
//
//  Created by Jason Dubon on 4/15/23.
//

import UIKit

class CustomButtonView: UIView {

    var didTapButton: ((SignInButton) -> Void)?
    
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: buttonLogo.rawValue, in: Bundle.module, with: nil)
        return imageView
        
    }()
    
    private lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign in with \(buttonLogo.rawValue)"
        label.font = .systemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    let buttonLogo: SignInButton
    init(buttonLogo: SignInButton) {
        self.buttonLogo = buttonLogo
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 30
        isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCustomButton))
        addGestureRecognizer(gesture)
        
        addSubview(buttonImageView)
        addSubview(buttonLabel)
        
        NSLayoutConstraint.activate([
            buttonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            buttonImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonImageView.widthAnchor.constraint(equalToConstant: 32),
            buttonImageView.heightAnchor.constraint(equalToConstant: 32),
            
            buttonLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            buttonLabel.heightAnchor.constraint(equalToConstant: 32),
        
        ])
    }
    
    @objc private func didTapCustomButton() {
        didTapButton?(buttonLogo)
    }
}
