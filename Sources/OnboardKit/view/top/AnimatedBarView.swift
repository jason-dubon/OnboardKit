//
//  AnimatedBarView.swift
//  
//
//  Created by Jason Dubon on 4/12/23.
//

import UIKit
import Combine

class AnimatedBarView: UIView {

    enum State {
        case clear
        case animating
        case filled
    }
    
    private lazy var backgroundBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = viewTintColor.withAlphaComponent(0.3)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var foregroundBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = viewTintColor
        view.layer.cornerRadius = 1
        view.alpha = 0.0
        return view
    }()
    
    @Published private var state: State = .clear
    private var subscribers = Set<AnyCancellable>()
    private var animator: UIViewPropertyAnimator!
    
    private let viewTintColor: UIColor
    init(tintColor: UIColor) {
        self.viewTintColor = tintColor
        
        super.init(frame: .zero)
        configureUI()
        setupAnimator()
        observeStates()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(backgroundBarView)
        backgroundBarView.addSubview(foregroundBarView)
        
        NSLayoutConstraint.activate([
            backgroundBarView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundBarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            foregroundBarView.topAnchor.constraint(equalTo: backgroundBarView.topAnchor, constant: 0),
            foregroundBarView.leadingAnchor.constraint(equalTo: backgroundBarView.leadingAnchor, constant: 0),
            foregroundBarView.trailingAnchor.constraint(equalTo: backgroundBarView.trailingAnchor, constant: 0),
            foregroundBarView.bottomAnchor.constraint(equalTo: backgroundBarView.bottomAnchor, constant: 0),
        ])
    }
    
    private func setupAnimator() {
        animator = UIViewPropertyAnimator(duration: 3.0,
                                          curve: .easeInOut,
                                          animations: {
                                            self.foregroundBarView.transform = .identity
                                        })
    }
    
    private func observeStates() {
        $state.sink { [unowned self] state in
            switch state {
            case .clear:
                setupAnimator()
                foregroundBarView.alpha = 0.0
                animator.stopAnimation(false)
            case .animating:
                foregroundBarView.transform = .init(scaleX: 0, y: 1.0)
                foregroundBarView.transform = .init(translationX: -frame.size.width, y: 0)
                foregroundBarView.alpha = 1.0
                animator.startAnimation()
            case .filled:
                animator.stopAnimation(true)
                foregroundBarView.transform = .identity

            }
        }.store(in: &subscribers)
    }
    
    // ONLY EXPOSES THESE TO PARENT/OWNER
    func startAnimating() {
        state = .animating
    }
    
    func reset() {
        state = .clear
    }
    
    func complete() {
        state = .filled
    }
}
