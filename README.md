<p align="center">
<img src="assets/OnboardKit.png" width="50%" alt="OnboardKit Logo" />
<br />
<img src="https://img.shields.io/badge/platform-iOS-blue.svg" alt="Supported Platforms: iOS" />
<a href="https://github.com/apple/swift-package-manager" alt="RxSwift on Swift Package Manager" title="RxSwift on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
</p>


# OnboardKit

OnboardKit is a Swift library that provides simple and easy onboarding and sign in flow for your iOS apps. 

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Credits](#credits)

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.0 or later


## Installation
There are two ways to use OnboardKit in your project:
- using Swift Package Manager
- manual install (build frameworks or embed Xcode Project)

### Swift Package Manager

To integrate OnboardKit into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/MexJason/OnboardKit.git", .upToNextMajor(from: "1.0.0"))
]
```

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

### Manually

If you prefer not to use Swift Package Manager, you can integrate OnboardKit into your project manually.

---

## Quick Start

## 1. Implement this in ViewController
```swift
import UIKit
import OnboardKit

class ViewController: UIViewController {

    // optional so we can deinit after onboarding
    private var onboardingKit: OnboardKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let slides = [
            Slide(image: UIImage(named: "image1")!, title: "InfraslimX"),
            Slide(image: UIImage(named: "image2")!, title: "The future of fitness is here"),
            Slide(image: UIImage(named: "image3")!, title: "Try it now!")
        ]
        
        self.onboardingKit = OnboardKit(onboardSlides: slides, onboardTintColor: .init(red: 1, green: 215/255, blue: 0, alpha: 1), signInPage: SignInPage(image: UIImage(named: "jason")!, title: "Sign In To Continue!"))
        self.onboardingKit?.launchOnboardingWithSignIn(rootVC: self)
        self.onboardingKit?.onboardDelegate = self
        self.onboardingKit?.signInDelegate = self
    }
}

extension ViewController: OnboardKitDelegate, OnboardKitSignInDelegate {
       
    func nextButtonDidTap(index: Int) {
        print(index)
    }
    
    func getStartedButtonDidTap() {
        print("get started")
    }
    
    func didTapSignInApple() {
        print("apple")
    }
    
    func didTapSignInGoogle() {
        print("google")
    }
}


```

## 2. In SceneDelegate, implement this function to transistion ViewControllers
```swift

func changeRootViewController(vc: UIViewController) {
    guard let window = window else {
        return
    }
    
    window.rootViewController = vc
    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
}

```


## Credits

- Jason Dubon
