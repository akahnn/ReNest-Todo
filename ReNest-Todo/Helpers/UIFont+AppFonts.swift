//
//  UIFont+AppFonts.swift
//  ReNest-Todo
//
//  Created by Abdullah Kahn on 9/14/18.
//  Copyright © 2018 Sifted. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func appBookFont(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Book", size: size)
    }
    
    class func appMediumFont(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Medium", size: size)
    }
    
    class func appBlackFont(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Black", size: size)
    }
    
    class func appHeavyFont(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "Avenir-Heavy", size: size)
    }
}
