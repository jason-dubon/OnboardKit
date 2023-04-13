//
//  TransitionView.swift
//  
//
//  Created by Jason Dubon on 4/12/23.
//

import UIKit

class TransitionView: UIView {

    private var timer: DispatchSourceTimer?
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var barViews: [AnimatedBarView] = {
        var views = [AnimatedBarView]()
        slides.forEach({_ in views.append(AnimatedBarView(tintColor: viewTintColor))})
        
        return views
    }()
    
    private lazy var barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // adds each AnimatedBarView to stackview
        barViews.forEach({stackView.addArrangedSubview($0)})
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var titleView: TitleView = {
        let view = TitleView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, titleView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.axis = .vertical
        
        return view
    }()
    
    private(set) var index: Int = -1
    private let slides: [Slide]
    private let viewTintColor: UIColor
    init(slides: [Slide], tintColor: UIColor) {
        self.slides = slides
        self.viewTintColor = tintColor
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(mainStackView)
        // Make sure bar views are on top of main view
        addSubview(barStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            barStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            barStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            barStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            barStackView.heightAnchor.constraint(equalToConstant: 4),
            
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.7),
            
        ])
    }
    
    func start() {
        buildTimerIfNeeded()
        timer?.resume()
    }
    
    func stop() {
        timer?.cancel()
        timer = nil
    }
    
    private func buildTimerIfNeeded() {
        guard timer == nil else { return }
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now(), repeating: .seconds(3), leeway: .seconds(1))
        timer?.setEventHandler(handler: {
            DispatchQueue.main.async { [weak self] in
                self?.showNext()
            }
        })
    }
    
    private func showNext() {
        let nextImage: UIImage
        let nextTitle: String
        let nextBarView: AnimatedBarView
        
        if index == (slides.count - 1) {
            barViews.forEach({$0.reset()})
            index = 0
            nextImage = slides[index].image
            nextTitle = slides[index].title
            nextBarView = barViews[index]
        } else {
            index += 1
            nextImage = slides[index].image
            nextTitle = slides[index].title
            nextBarView = barViews[index]
        }
        
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve) {
            self.imageView.image = nextImage
        }
        titleView.setTitle(text: nextTitle)
        nextBarView.startAnimating()
    }
    
    func handleTap(direction: Direction) {
        switch direction {
        case .left:
            barViews[index].reset()
            if index != barViews.count - 1 {
                barViews[index-1].reset()
            }
            index -= 2
            
        case .right:
            barViews[index].complete()
        }
        stop()
        start()
    }


}
