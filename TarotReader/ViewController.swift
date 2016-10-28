//
//  ViewController.swift
//  TarotReader
//
//  Created by Scott Richards on 10/28/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tarotCardImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var cardShowing : Bool = false
    var deckOfCards : TarotCardDeck = TarotCardDeck()
    var cardCount : UInt32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(onClickTarotCard))
        tarotCardImage.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
        deckOfCards.readJSONFile()
        cardCount = deckOfCards.cards != nil ? UInt32(deckOfCards.cards!.count) : 0
        descriptionLabel.text = Constants.Strings.ClickToSelect
    }
    
    func onClickTarotCard() {
        if (cardShowing) {
            titleLabel.text = ""
            self.tarotCardImage.image = UIImage(named: "CardBack")
            descriptionLabel.text = Constants.Strings.ClickToSelect
        } else {
            let randomNumber = Int(arc4random_uniform(cardCount))
            print("random Number: \(randomNumber)")
            if let selectedTarotCard = deckOfCards.cards?[randomNumber] {
                if let imagePath = selectedTarotCard.image {
                    print("load image: \(imagePath)")
                    self.tarotCardImage.image = UIImage(named: imagePath)
                }
                if let titleText = selectedTarotCard.title {
                    titleLabel.text = titleText
                }
                if let descriptionText = selectedTarotCard.text {
                    descriptionLabel.text = descriptionText
                }
            }
        }
        cardShowing = !cardShowing
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

