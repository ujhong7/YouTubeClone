//
//  TabButtonCVC.swift
//  youtubeSubsTab
//
//  Created by yujaehong on 5/7/24.
//

import UIKit

final class TabButtonCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let tapGesture = UITapGestureRecognizer(target: TabButtonCollectionViewCell.self, action: #selector(containerViewTapped))
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupAutoLayout()
        //setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func configureUI() {
        self.backgroundColor = .systemBackground
    }
    
    private func setupAutoLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 11),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -11),
        ])
    }
    
    private func setupTapGesture() {
        let containerViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(containerViewTapped))
        containerView.addGestureRecognizer(containerViewTapGesture)
    }
    
    func configure(text: String) {
        label.text = text
    }
    
    // MARK: - @objc
    
    @objc private func containerViewTapped() {
        print(#function)
    }
}
