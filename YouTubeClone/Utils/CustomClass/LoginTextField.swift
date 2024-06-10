//
//  LoginTextField.swift
//  YouTubeClone
//
//  Created by yujaehong on 4/2/24.
//

import UIKit

final class LoginTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLeftPadding(width: CGFloat, height: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    private func configureTextField() {
        self.font = UIFont.systemFont(ofSize: 15)
        self.borderStyle = .roundedRect
        self.addLeftPadding(width: 14, height: 1)
    }
}

