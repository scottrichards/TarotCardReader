//
//  TarotCardDeck.swift
//  TarotReader
//
//  Created by Scott Richards on 10/28/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class TarotCardDeck: NSObject {
    var cards : [TarotCard]?
    
    func readJSONFile() {
        if let contentJsonPath = Bundle.main.path(forResource: "Cards", ofType: "json") {
            let contentJsonString = try! NSString(contentsOfFile: contentJsonPath, encoding: String.Encoding.utf8.rawValue)
            if let jsonData = contentJsonString.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false) {
                let dictionary : NSDictionary = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! NSDictionary
                if let cardsNodes = dictionary["cards"] as? [AnyObject] {
                    cards = [TarotCard]()
                    for cardNode in cardsNodes {
                        let card = TarotCard(jsonData: cardNode as! [String : String])
                        cards?.append(card)
                    }
                }
            }
        }
    }
}
