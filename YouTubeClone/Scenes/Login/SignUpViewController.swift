//
//  SignUpViewController.swift
//  YouTubeClone
//
//  Created by yujaehong on 3/25/24.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    private let loginInfoStackView = LoginInfoStackView()
    
    private var isAllFieldsFilled: Bool = false {
        didSet {
            nextButton.backgroundColor = isAllFieldsFilled ? .customBlue : .lightGray
            nextButton.isEnabled = isAllFieldsFilled
        }
    }
    
    private let logoImageView = UIImageView(image: UIImage(named: "Googlelogo"))
    
    private let headGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let passwordToggleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 표시"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    private let passwordCheckBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.imageView?.tintColor = .lightGray
        button.isSelected = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addTarget()
    }
    
    deinit {
        print("SignUpViewController 해제")
    }
    
    private func addTarget() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        passwordCheckBox.addTarget(self, action: #selector(passwordCheckBoxTapped(_:)), for: .touchUpInside)
        [loginInfoStackView.nameTextField, loginInfoStackView.idTextField, loginInfoStackView.passwordTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        isAllFieldsFilled = loginInfoStackView.isAllFieldsFilled
    }
    
    @objc func nextButtonTapped() {
        print(#function)
        guard let name = loginInfoStackView.nameTextField.text else { return }
        let signUpSuccessVC = LoginSuccessViewController(name: name)
        
        present(signUpSuccessVC, animated: true)
    }
    
    @objc func passwordCheckBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        loginInfoStackView.passwordTextField.isSecureTextEntry = !sender.isSelected
        
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
            sender.imageView?.tintColor = .customBlue
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            sender.imageView?.tintColor = .lightGray
        }
    }
}

extension SignUpViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        [logoImageView, headGuideLabel, loginInfoStackView,
         passwordCheckBox, passwordToggleLabel, nextButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 118),
            
            headGuideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headGuideLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 23),
            
            loginInfoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            loginInfoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            loginInfoStackView.topAnchor.constraint(equalTo: headGuideLabel.bottomAnchor, constant: 128),
            loginInfoStackView.heightAnchor.constraint(equalToConstant: 178),
            
            passwordCheckBox.topAnchor.constraint(equalTo: loginInfoStackView.bottomAnchor, constant: 17),
            passwordCheckBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            passwordCheckBox.widthAnchor.constraint(equalToConstant: 16),
            passwordCheckBox.heightAnchor.constraint(equalToConstant: 16),
            
            passwordToggleLabel.centerYAnchor.constraint(equalTo: passwordCheckBox.centerYAnchor),
            passwordToggleLabel.leadingAnchor.constraint(equalTo: passwordCheckBox.trailingAnchor, constant: 11),
            
            nextButton.topAnchor.constraint(equalTo: passwordToggleLabel.bottomAnchor, constant: 29),
            nextButton.leadingAnchor.constraint(equalTo: loginInfoStackView.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: loginInfoStackView.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
}
