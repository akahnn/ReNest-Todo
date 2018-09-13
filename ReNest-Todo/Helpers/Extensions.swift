//
//  Extensions.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/13/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func reloadDataAnimated() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { self.reloadData() }, completion: nil)
    }
    
}

extension CALayer {
    
    func applySketchShadow (
        
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
    }
    
}
