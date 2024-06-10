//
//  UILabel+.swift
//  YouTubeClone
//
//  Created by yujaehong on 4/2/24.
//

import UIKit

extension UILabel {
    ///  행 간격 설정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}
