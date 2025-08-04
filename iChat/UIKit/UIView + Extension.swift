//
//  UIView + Extension.swift
//  iChatHomework
//
//  Created by David Puksanskis on 24/07/2025.
//

import UIKit


extension UIView {
    
    
    
    func applyGradients(cornerRadius: CGFloat) {
        
        self.backgroundColor = nil
        self.layoutIfNeeded()
        
        let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: #colorLiteral(red: 0.8114481568, green: 0.6728828549, blue: 0.9536764026, alpha: 1), endColor: #colorLiteral(red: 0.5273995399, green: 0.7350654006, blue: 0.9380874038, alpha: 1))
        
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
}
