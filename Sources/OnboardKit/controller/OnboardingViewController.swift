//
//  OnboardingViewController.swift
//  
//
//  Created by Jason Dubon on 4/12/23.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var nextButtonDidTap: ((Int) -> Void)?
    var getStartedButtonDidTap: (() -> Void)?

    private let slides: [Slide]
    private let tintColor: UIColor
    
    
    private lazy var transitionView: TransitionView = {
        let view = TransitionView(slides: slides, tintColor: tintColor)
        
        return view
    }()
    
    private lazy var buttonContainerView: ButtonContainerView = {
        let view = ButtonContainerView(tintColor: tintColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.nextButtonDidTap = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.nextButtonDidTap?(strongSelf.transitionView.index)
            strongSelf.transitionView.handleTap(direction: .right)
            
            // how to inform OnboardingKit that the next button has been tapped on ?
        }
        view.getStartedButtonDidTap = getStartedButtonDidTap
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [transitionView, buttonContainerView])
        view.axis = .vertical
        return view
    }()
    
    init(slides: [Slide], tintColor: UIColor) {
        self.slides = slides
        self.tintColor = tintColor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        configureViews()
        setupTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        transitionView.start()
    }
    
    func stopAnimation() {
        transitionView.stop()
    }
    
    private func configureViews() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            buttonContainerView.heightAnchor.constraint(equalToConstant: 120),
            
        ])
        
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        transitionView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapView(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: view)
        
        let midPoint = view.frame.midX
        if point.x < midPoint {
            transitionView.handleTap(direction: .left)
        } else {
            transitionView.handleTap(direction: .right)
        }
    }
}
