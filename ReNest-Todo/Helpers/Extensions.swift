//
//  Extensions.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/13/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Task {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true)]
    }

    static var sortedFetchRequest: NSFetchRequest<Task> {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = Task.defaultSortDescriptors
        return request
    }

    static var incompletedFetchRequest: NSFetchRequest<Task> {
        let request = Task.sortedFetchRequest
        request.predicate = NSPredicate(format: "completed == %@", NSNumber(booleanLiteral: false))
        return request
    }

    static var completedFetchRequest: NSFetchRequest<Task> {
        let request = Task.sortedFetchRequest
        request.predicate = NSPredicate(format: "completed == %@", NSNumber(booleanLiteral: true))
        return request
    }

}

extension String {

    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }

    func textWidth(font: UIFont?) -> CGFloat {
        let attributes = font != nil ? [NSAttributedStringKey.font: font] : [:]
        return self.size(withAttributes: attributes).width
    }
}

extension UITableView {

    func reloadDataAnimated() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { self.reloadData() }, completion: nil)
    }

}

extension UIView {

    func applyGradient(colours: [UIColor], alpha: Float) -> Void {
        self.applyGradient(colours: colours, locations: nil, alpha: alpha)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?, alpha: Float) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.opacity = alpha
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
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
