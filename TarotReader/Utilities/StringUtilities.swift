//
//  StringUtilities.swift
//  Trainsweet
//
//  Created by Scott Richards on 10/16/16.
//  Copyright © 2016 Ricky Reed. All rights reserved.
//

import UIKit

class StringUtilities: NSObject {
    class func getLocalizedString(stringKey key: String, comment : String? = nil) -> String {
        let comment = comment ?? ""
        let localizedString : String = NSLocalizedString(key, comment: comment)
        return localizedString
    }
}
