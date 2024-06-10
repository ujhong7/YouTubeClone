//
//  loginInfoStackView.swift
//  YouTubeClone
//
//  Created by yujaehong on 3/25/24.
//

import UIKit

final class LoginInfoStackView: UIStackView {
    
    let nameTextField: LoginTextField = {
        let textField = LoginTextField()
        textField.placeholder = "이름을 입력해주세요."
        return textField
    }()
    
    let idTextField: LoginTextField = {
        let textField = LoginTextField()
        textField.placeholder = "이메일 또는 휴대전화"
        return textField
    }()
    
    let passwordTextField: LoginTextField = {
        let textField = LoginTextField()
        textField.placeholder = "비밀번호 입력"
        return textField
    }()
    
    
    var isAllFieldsFilled: Bool {
        return !nameTextField.text!.isEmpty && !idTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTextFieldDelegate()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 17
        [nameTextField, idTextField, passwordTextField].forEach { addArrangedSubview($0) }
    }
    
    private func setupTextFieldDelegate() {
        [nameTextField, idTextField, passwordTextField].forEach { $0.delegate = self }
    }
}

extension LoginInfoStackView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            idTextField.becomeFirstResponder()
        } else if textField == idTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
