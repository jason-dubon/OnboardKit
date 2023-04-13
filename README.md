<p align="center">
<img src="assets/OnboardKit.png" width="50%" alt="OnboardKit Logo" />
<br />
<img src="https://img.shields.io/badge/platform-iOS-blue.svg" alt="Supported Platforms: iOS" />
<a href="https://github.com/apple/swift-package-manager" alt="RxSwift on Swift Package Manager" title="RxSwift on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
</p>


# OnboardKit

OnboardKit is a Swift library that provides simple and easy onboarding flow for your iOS apps.

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
  
  private var onboardKit: OnboardKit?

  override func viewDidLoad() {
    super.viewDidLoad()
    DispatchQueue.main.async {
      self.onboardKit = OnboardKit(
        slides: [
          .init(image: UIImage(named: "image1")!,
                title: "The future "),
          .init(image: UIImage(named: "image2")!,
                title: "Stack your rewards every time you pay"),
          .init(image: UIImage(named: "image3")!,
                title: "Enjoy now, FavePay Later"),
        ],
        tintColor: UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1.0),
        themeFont: UIFont(name: "American Typewriter Bold", size: 28) ?? .systemFont(ofSize: 28, weight: .bold))
      self.onboardKit?.delegate = self
      self.onboardKit?.launchOnboarding(rootVC: self)
    }
  }
}

extension ViewController: OnboardKitDelegate {
  func nextButtonDidTap(index: Int) {
    print("next button is tapped at index: \(index)")
  }
  
  func getStartedButtonDidTap() {
    onboardKit?.dismissOnboarding()
    onboardKit = nil
    
    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc: MainViewController())
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


## 3. ViewController to transition to after onboarding
``` swift
class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemYellow
  }
  
}

```

## Credits

- Jason Dubon
