//
//  UiColorExtension.swift
//  CallerRate
//
//  Created by Ali Merhie on 11/28/19.
//  Copyright © 2019 Monty Mobile. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex:String) {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            self.init(red: 0, green: 0, blue: 0, alpha: CGFloat(1))
            return
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}

extension UIColor {
    
    class var primary: UIColor {
        UIColor(named: "primary")!
    }
    
    class var main_green: UIColor {
        UIColor(named: "main_green")!
    }
    class var main_red: UIColor {
        UIColor(named: "main_red")!
    }
    class var textPrimary_33_F2: UIColor {
        UIColor(named: "textPrimary_33_F2")!
    }
    class var lightLavender: UIColor {
        UIColor(named: "lightLavender")!
    }
    
    class var pinkishGrey: UIColor {
        return UIColor(named: "pinkishGrey")!
    }
    
    class var veryLightPink: UIColor {
        return UIColor(named: "veryLightPink")!
    }
    
    class var brownGrey: UIColor {
        return UIColor(named: "brownGrey")!
    }
    
    class var white245: UIColor {
        return UIColor(named: "white245")!
    }
    
    class var charcoalGrey: UIColor {
        return UIColor(named: "charcoalGrey")!
    }
    
    class var charcoalGrey2: UIColor {
        return UIColor(named: "charcoalGrey2")!
    }
    
    class var tealish: UIColor {
        return UIColor(named: "tealish")!
    }
    
    class var lightGreyBlue: UIColor {
        return UIColor(named: "lightGreyBlue")!
    }
}



