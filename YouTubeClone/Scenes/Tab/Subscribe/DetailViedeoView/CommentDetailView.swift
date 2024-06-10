//
//  CommentDetailView.swift
//  YouTubeClone
//
//  Created by yujaehong on 6/8/24.
//

import UIKit

class CommentDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        // 드래그 제스처 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemPink
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed {
            if translation.y > 0 {
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        } else if gesture.state == .ended {
            if translation.y > 100 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: 300)
                }) { _ in
                    self.removeFromSuperview()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.transform = .identity
                }
            }
        }
    }
}
