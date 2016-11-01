//
//  ColorExtension.swift
//  Trainsweet
//
//  Created by Scott Richards on 9/12/16.
//  Copyright © 2016 Ricky Reed. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    public class func rgbColor(red r: UInt8, green g: UInt8, blue b:UInt8, alpha a: Float) -> UIColor {
        let redValue = CGFloat(r) / 255.0
        let greenValue = CGFloat(g) / 255.0
        let blueValue = CGFloat(b) / 255.0
        let color = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: CGFloat(a))
        return color
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
   
    public class func softGreen() -> UIColor {
        return UIColor(netHex:0x66cc66)
    }

    public class func colorWithHexString (hex:String) -> UIColor {
        
        var rString = (hex as NSString).substring(to:2)
        var rightString = (hex as NSString).substring(from:2)
        
        var gString = (rightString as NSString).substring(to:2)
        var rightMostString = (hex as NSString).substring(from:4)
        
        var bString = (rightMostString as NSString).substring(to:2)
       
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: Int(r), green: Int(g), blue: Int(b))
    }
}
