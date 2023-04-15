//
//  File.swift
//  
//
//  Created by Jason Dubon on 4/15/23.
//

import UIKit

class TermsAndCondititonsView: UIView {

    var didTapTermsService: (() -> Void)?
    var didTapPrivacyPolicy: (() -> Void)?
    
    private lazy var termsAndConditionsLabel: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.tintColor = .black
        
        let labelText = "By signing in you agree to Terms of Service and Privacy Policy."
        
        // 4th create the first piece of the string you don't want to be tappable
        let regularText = NSMutableAttributedString(string: "By signing in you agree to ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.black])

        // 5th create the second part of the string that you do want to be tappable. I used a blue color just so it can stand out.
        let tappableTermsText = NSMutableAttributedString(string: "Terms of Service")
        tappableTermsText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, tappableTermsText.length))
        tappableTermsText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, tappableTermsText.length))

        // 6th this ISN'T NECESSARY but this is how you add an underline to the tappable part. I also used a blue color so it can match the tappableText and set the value to 1 for the line height. The length of the underline is based on the tappableText's length using NSMakeRange(0, tappableText.length)
        tappableTermsText.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, tappableTermsText.length))
        tappableTermsText.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.black, range: NSMakeRange(0, tappableTermsText.length))

        // 7th this is the important part that connects the tappable link to the delegate method in step 11
        // use NSAttributedString.Key.link and the value "makeMeTappable" to link the NSAttributedString.Key.link to the method. FYI "makeMeTappable" is a name I choose for clarity, you can use anything like "anythingYouCanThinkOf"
        tappableTermsText.addAttribute(NSAttributedString.Key.link, value: "terms", range: NSMakeRange(0, tappableTermsText.length))

        let moreText = NSMutableAttributedString(string: " and ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.black])
        
        // 5th create the second part of the string that you do want to be tappable. I used a blue color just so it can stand out.
        let tappablePrivacyText = NSMutableAttributedString(string: "Privacy Policy")
        tappablePrivacyText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, tappablePrivacyText.length))
        

        // add an underline to the tappable part.
        tappablePrivacyText.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, tappablePrivacyText.length))
        tappablePrivacyText.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.black, range: NSMakeRange(0, tappablePrivacyText.length))

        // 7th this is the important part that connects the tappable link to the delegate method in step 11
        // use NSAttributedString.Key.link and the value "makeMeTappable" to link the NSAttributedString.Key.link to the method.
        tappablePrivacyText.addAttribute(NSAttributedString.Key.link, value: "privacy", range: NSMakeRange(0, tappablePrivacyText.length))
        
        tappablePrivacyText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, tappablePrivacyText.length))
        
        let lastText = NSMutableAttributedString(string: ".", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        
        // 8th *** important append the tappableText to the regularText ***
        regularText.append(tappableTermsText)
        regularText.append(moreText)
        regularText.append(tappablePrivacyText)
        regularText.append(lastText)
        
        regularText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, regularText.length))
        
        // 9th set the regularText to the textView's attributedText property
        textView.attributedText = regularText
        
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.textAlignment = .center
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        addSubview(termsAndConditionsLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            termsAndConditionsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            termsAndConditionsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            termsAndConditionsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            termsAndConditionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension TermsAndCondititonsView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "terms" {
            didTapTermsService?()
        } else if URL.absoluteString == "privacy" {
            didTapPrivacyPolicy?()
        }

        return false
    }
}
