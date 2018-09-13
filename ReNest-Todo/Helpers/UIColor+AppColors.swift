//
//  UIColor+AppColors.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/11/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit
import SwiftHEXColors

extension UIColor {
    
    struct AppColor {
        
        struct App {
            static let Background = UIColor(hex: 0xF4F7FA)
            static let ReNestPurple = UIColor(hex: 0x32315C)
            static let TaskCompleted = UIColor(hex: 0x32315C, alpha: 0.3)
            static let Icon = UIColor(hex: 0x32315C, alpha: 0.5)
            static let TickMark = UIColor(hex: 0x32315C, alpha: 0.4)
            static let CircleEmpty = UIColor(hex: 0x32315C, alpha: 0.5)
            static let CircleFilled = UIColor(hex: 0x32315C, alpha: 0.05)
            static let SearchText = UIColor(hex: 0x1D1D26, alpha: 0.5)
            static let ShadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 2);
        }
        
        struct Priority {
            static let High = UIColor(hex: 0xFF2765)
            static let Normal = UIColor(hex: 0x48CE00)
            static let Low = UIColor(hex: 0x4196EA)
        }
        
        struct Segment {
            static let Selected = UIColor(hex: 0x1D1D26)
            static let Unselected = UIColor(hex: 0x32315C, alpha: 0.3)
        }
     
    }
}
