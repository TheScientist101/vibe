//
//  ConnectButton.swift
//  vibe
//
//  Created by Jayden Chun on 5/22/25.
//

import UIKit

class ConnectButton: UIButton {

    fileprivate let buttonBackgroundColor =
        UIColor(red:(29.0 / 255.0), green:(185.0 / 255.0), blue:(84.0 / 255.0), alpha:1.0)
    fileprivate let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .heavy),
        .foregroundColor: UIColor.white,
        .kern: 2.0
    ]

    init(title: String) {
        super.init(frame: CGRect.zero)
        backgroundColor = buttonBackgroundColor
        layer.cornerRadius = 20.0
        translatesAutoresizingMaskIntoConstraints = false
        let title = NSAttributedString(string: title, attributes: titleAttributes)
        setAttributedTitle(title, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview{
    ConnectButton(title: "Connect")
}
