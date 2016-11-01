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
    @IBOutlet weak var backgroundImageView: UIImageView!
    
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
        self.view.backgroundColor = UIColor.init(netHex: Constants.Colors.MainBackground)   // 543517
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
//        backgroundImageView.image = UIImage(named: "Background")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func onClickTarotCard() {
        if (cardShowing) {
            titleLabel.text = ""
            self.tarotCardImage.image = UIImage(named: "CardBack")
            descriptionLabel.text = Constants.Strings.ClickToSelect
            self.view.backgroundColor = UIColor.init(netHex: Constants.Colors.MainBackground)   // 543517
        } else {
            let randomNumber = Int(arc4random_uniform(cardCount))
            print("random Number: \(randomNumber)")
            


            if let selectedTarotCard = deckOfCards.cards?[randomNumber] {
                if let hexColorStr = selectedTarotCard.color {
                    self.view.backgroundColor = UIColor.colorWithHexString(hex:hexColorStr)
                }
                if let imagePath = selectedTarotCard.image {
                    print("load image: \(imagePath)")
                    self.tarotCardImage.image = UIImage(named: imagePath)
                }
                if let titleText = selectedTarotCard.title {
                    titleLabel.text = titleText
                } else {
                    titleLabel.text = ""
                }
                if let affirmationText = selectedTarotCard.affirmation {
                    descriptionLabel.text = affirmationText
                } else {
                    descriptionLabel.text = ""
                }
                
            }
        }
        cardShowing = !cardShowing
    }

    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                
                print("Swiped right")
                
                //change view controllers
                
                
                
                
                
            default:
                break
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

