//
//  ViewController.swift
//  TarotReader
//
//  Created by Scott Richards on 10/28/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cardFaceImageView: UIImageView!      // The face of the card with Reading and affirmation
    @IBOutlet weak var cardBackImageView: UIImageView!      // The back of the card with the Oracle
    @IBOutlet weak var cardHolderView: UIView!      // Container View for the face or back of the card
    
    var cardShowing : Bool = false
    var deckOfCards : TarotCardDeck = TarotCardDeck()
    var cardCount : UInt32 = 0
    var currentCard : UInt32 = 0
    var startLocation : CGPoint?
    var movingCard : Bool = false
    
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
        
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]
        for direction in directions {
            var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
            swipeGesture.direction = direction
            self.cardFaceImageView.addGestureRecognizer(swipeGesture)
        }

        self.cardBackImageView.isUserInteractionEnabled = true
        self.cardFaceImageView.isUserInteractionEnabled = true
        
        // clear out the back button navigation item
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.tintColor = UIColor(netHex: Constants.Colors.MainBackground)
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture(gesture:)))
//        self.cardFaceImageView.addGestureRecognizer(panGestureRecognizer)
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
        self.navigationItem.title = "Change Me Prayers"
//        UIView.transition(from: cardFaceImageView, to: cardBackImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
    }
    
    func animateCard(count:Int) -> TarotCard? {
        currentCard = UInt32(count)
        if let selectedTarotCard = deckOfCards.cards?[count] {
            UIView.animate(withDuration: 0.7, animations: {
                if let hexColorStr = selectedTarotCard.color {
                    self.view.backgroundColor = UIColor.colorWithHexString(hex:hexColorStr)
                }
                self.cardFaceImageView.alpha = 0.2
                if let imagePath = selectedTarotCard.image {
                    print("load image: \(imagePath)")
                    self.cardFaceImageView.image = UIImage(named: imagePath)
                }
                self.cardFaceImageView.alpha = 1
                if let titleText = selectedTarotCard.title {
                    self.titleLabel.text = titleText
                    self.navigationItem.title = titleText
                } else {
                    self.titleLabel.text = ""
                }
                if let affirmationText = selectedTarotCard.affirmation {
                    self.descriptionLabel.text = affirmationText
                } else {
                    self.descriptionLabel.text = ""
                }

                }, completion: nil)
                       return selectedTarotCard
        }
        return nil
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
                self.navigationItem.title = titleText
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
                } else {
                    currentCard = cardCount - 1
                }
                animateCard(count: Int(currentCard))
                
                //change view controllers
            case UISwipeGestureRecognizerDirection.left :
                print("Swiped Left")
                
                let cardCount :UInt32 = deckOfCards.cards != nil ? UInt32(deckOfCards.cards!.count) : 0
                if (currentCard <  cardCount - 1) {
                    currentCard += 1
                } else {
                    currentCard = 1
                }
                animateCard(count: Int(currentCard))
            default:
                break
            }
        }
    }
    
    
    func respondToPanGesture(gesture:UIPanGestureRecognizer) {
        if (!movingCard) {
         //   self.cardFaceImageView.translatesAutoresizingMaskIntoConstraints = false
        }
        let location = gesture.location(in: self.view)
        if location.x >= self.view.frame.size.width {
            print("Next Card")
        }
        let translation : CGPoint = gesture.translation(in: self.cardBackImageView)
        cardFaceImageView.center = CGPoint(x:  translation.x + (startLocation?.x)!, y: (startLocation?.y)!)
        if (gesture.state == UIGestureRecognizerState.ended) {
            animateBack()
            movingCard = false
      //      self.cardFaceImageView.translatesAutoresizingMaskIntoConstraints = true
        } else {
            movingCard = true
        }
    }
    
    // animate card back to its original position
    func animateBack()
    {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.cardFaceImageView!.center = self.startLocation!
            }, completion: { finished in
                print("Tarot card back home")
        })
        
    }

    
    
    @IBAction func onShare(_ sender: AnyObject) {
        
        print("share")
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Share on Facebook")
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

}

