//
//  ViewController.swift
//  TarotReader
//
//  Created by Scott Richards on 10/28/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cardFaceImageView: UIImageView!
    @IBOutlet weak var cardBackImageView: UIImageView!
    @IBOutlet weak var cardHolderView: UIView!      // Container View for the face or back of the card
    
    var cardShowing : Bool = false
    var deckOfCards : TarotCardDeck = TarotCardDeck()
    var cardCount : UInt32 = 0
    var currentCard : UInt32 = 0
    var startLocation : CGPoint?
    
    override func viewDidLayoutSubviews() {
        startLocation = cardBackImageView?.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(onClickTarotCard))
        cardHolderView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
        deckOfCards.readJSONFile()
        cardCount = deckOfCards.cards != nil ? UInt32(deckOfCards.cards!.count) : 0
        descriptionLabel.text = Constants.Strings.ClickToSelect
        self.view.backgroundColor = UIColor.init(netHex: Constants.Colors.MainBackground)   // 543517
        
        startLocation = cardBackImageView.center
        
        self.cardBackImageView.isUserInteractionEnabled = true
        self.cardFaceImageView.isUserInteractionEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture(gesture:)))
        self.cardFaceImageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startLocation = cardBackImageView.center
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func onClickTarotCard() {
        if (cardShowing) {
            showCardBack()
        } else {
            let randomNumber = Int(arc4random_uniform(cardCount))
            print("random Number: \(randomNumber)")
            
            let selectedCard = setCard(count: randomNumber)
//            UIView.transition(from: cardBackImageView, to: cardFaceImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            UIView.transition(with: cardHolderView, duration: 0.7, options: [.transitionFlipFromRight], animations: { [unowned self] in
                self.cardFaceImageView.isHidden = false
                self.cardBackImageView.isHidden = true
                if let hexColorStr = selectedCard?.color {
                    self.view.backgroundColor = UIColor.colorWithHexString(hex:hexColorStr)
                }
            })
        }
        cardShowing = !cardShowing
    }

    // show the Back card
    func showCardBack() {
        titleLabel.text = ""
  //      self.tarotCardImage.image = UIImage(named: "CardBack")
        descriptionLabel.text = Constants.Strings.ClickToSelect
        //self.view.backgroundColor = UIColor.init(netHex: Constants.Colors.MainBackground)

        UIView.transition(with: cardHolderView, duration: 0.7, options: [.transitionFlipFromLeft], animations: { [unowned self] in
            self.cardFaceImageView.isHidden = true
            self.cardBackImageView.isHidden = false
            self.view.backgroundColor = UIColor(netHex: Constants.Colors.MainBackground)
            })
        
//        UIView.transition(from: cardFaceImageView, to: cardBackImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
    }
    
    
    // set the card to the card at count#
    func setCard(count:Int) -> TarotCard? {
        currentCard = UInt32(count)
        if let selectedTarotCard = deckOfCards.cards?[count] {
//            if let hexColorStr = selectedTarotCard.color {
//                self.view.backgroundColor = UIColor.colorWithHexString(hex:hexColorStr)
//            }
            if let imagePath = selectedTarotCard.image {
                print("load image: \(imagePath)")
                self.cardFaceImageView.image = UIImage(named: imagePath)
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
            return selectedTarotCard
        }
        return nil
    }
    
    // MARK: Swipe Gestures
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                
                if (currentCard > 0) {
                    currentCard -= 1
                    setCard(count: Int(currentCard))
                } else {
                    showCardBack()
                }
                
                //change view controllers
            case UISwipeGestureRecognizerDirection.left :
                print("Swiped Left")
                
                let cardCount :UInt32 = deckOfCards.cards != nil ? UInt32(deckOfCards.cards!.count) : 0
                if (currentCard <  cardCount - 1) {
                    currentCard += 1
                    setCard(count: Int(currentCard))
                } else {
                    showCardBack()
                }
            default:
                break
            }
        }
    }
    
    
    func respondToPanGesture(gesture:UIPanGestureRecognizer) {
        let location = gesture.location(in: self.view)
        if location.x >= self.view.frame.size.width {
            print("Next Card")
        }
        let translation : CGPoint = gesture.translation(in: self.cardBackImageView)
         cardBackImageView.center = CGPoint(x:  translation.x + (startLocation?.x)!, y: (startLocation?.y)!)
        if (gesture.state == UIGestureRecognizerState.ended) {
            animateBack()
        }
    }
    
    // animate dog back to its original position
    func animateBack()
    {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.cardBackImageView!.center = self.startLocation!
            }, completion: { finished in
                print("Tarot card back home")
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

