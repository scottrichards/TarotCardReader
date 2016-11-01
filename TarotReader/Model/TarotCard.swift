//
//  TarotCard.swift
//  TarotReader
//
//  Created by Scott Richards on 10/28/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import Foundation

class TarotCard: NSObject {
    var title : String?
    var text : String?
    var affirmation : String?
    var image : String?
    var color : String?
    
    init(jsonData:[String:String]) {
        self.title = jsonData["title"]
        self.text = jsonData["text"]
        self.affirmation = jsonData["affirmation"]
        self.image = jsonData["image"]
        self.color = jsonData["color"]
    }
}
