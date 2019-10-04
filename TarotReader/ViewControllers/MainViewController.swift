//
//  ViewController.swift
//  TarotReader
//
//  Created by Scott Richards on 10/28/16.
//  Copyright © 2016 Scott Richards. All rights reserved.
//

import UIKit
import Social
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cardFaceImageView: UIImageView!      // The face of the card with Reading and affirmation
    @IBOutlet weak var cardBackImageView: UIImageView!      // The back of the card with the Oracle
    @IBOutlet weak var cardHolderView: UIView!      // Container View for the face or back of the card
    @IBOutlet weak var tapSwipeIconImage: UIImageView!
    
    var cardShowing : Bool = false
    var deckOfCards : TarotCardDeck = TarotCardDeck()
    var cardCount : UInt32 = 0
    var currentCard : UInt32 = 0
    var startLocation : CGPoint?
    var cardStartRect : CGRect?
    var cardState : CardState = .initial
    
    var panGestureRecognizer : UIPanGestureRecognizer?
    var audioPlayer = AVAudioPlayer()
    let emailComposer = EmailComposer()
    
    @IBOutlet weak var cardLeadingMargin: NSLayoutConstraint!
    @IBOutlet weak var cardTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var instructionLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var instructionViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var centerInstructionContainer: NSLayoutConstraint!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    enum CardDisplay {
        case Face, Back
    }
    
    enum CardState {
        case initial, dragging, animating
    }
    
    override func viewDidLayoutSubviews() {
        startLocation = cardBackImageView?.center
        cardStartRect = cardBackImageView.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soundSetup()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(onClickTarotCard))
        cardHolderView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
        deckOfCards.readJSONFile()
        cardCount = deckOfCards.cards != nil ? UInt32(deckOfCards.cards!.count) : 0
        descriptionLabel.text = StringUtilities.getLocalizedString(stringKey: Constants.Strings.Main.CardBackTap)
        self.view.backgroundColor = UIColor.init(netHex: Constants.Colors.MainBackground)   // 543517
        
        startLocation = cardBackImageView.center
        cardStartRect = cardBackImageView.frame
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
        setConstraintsForDevice()
        
//        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture(gesture:)))
//        self.cardFaceImageView.addGestureRecognizer(panGestureRecognizer!)
    }
    
    func setConstraintsForDevice() {
        let screenSize: CGRect = UIScreen.main.bounds
        print("width: \(screenSize.width)")
        if (screenSize.width >= 768) {
            print("current leading Margin: \(cardLeadingMargin.constant)")
            print("current trailing Margin: \(cardTrailingMargin.constant)")
            cardLeadingMargin.constant = 57
            cardTrailingMargin.constant = 57
        }
        if (screenSize.width <= 320) {
            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            centerInstructionContainer.isActive = false
            instructionViewWidth.constant = UIScreen.main.bounds.width - 28
            instructionViewWidth.constant = UIScreen.main.bounds.width - 95
        }
//        if (instructionViewWidth.constant > UIScreen.main.bounds.width) {
//            instructionViewWidth.constant = UIScreen.main.bounds.width - 28
//            instructionViewWidth.constant = UIScreen.main.bounds.width - 95
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startLocation = cardBackImageView.center
        cardStartRect = cardBackImageView.frame
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    // ------------------------------------
    // MARK: Sound
    // ------------------------------------
    
    func soundSetup() {
        let drawCardClip = NSURL(fileURLWithPath: Bundle.main.path(forResource: "flipcard", ofType: "wav")!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: drawCardClip as URL)
        } catch {
            print("Error loading Audio drawcard.wav")
            return
        }
        audioPlayer.prepareToPlay()
    }
    
    func playDrawSound() {
       audioPlayer.play()
    }
    
    @objc func onClickTarotCard() {
    //    playDrawSound()
        if (cardShowing) {
            rightBarButtonItem.image = UIImage(named: "QuestionCircle")
            
            showCardBack()
        } else {
            rightBarButtonItem.image = UIImage(named: "Share")
            
            let randomNumber = Int(arc4random_uniform(cardCount))
            print("random Number: \(randomNumber)")
            
            let selectedCard = setCard(count: randomNumber)
//            UIView.transition(from: cardBackImageView, to: cardFaceImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            
            UIView.transition(with: cardHolderView, duration: 1.2, options: [.transitionCrossDissolve], animations: { [unowned self] in
                self.descriptionLabel.text = StringUtilities.getLocalizedString(stringKey: Constants.Strings.Main.CardFaceSwipe)
                self.cardFaceImageView.isHidden = false
                self.cardBackImageView.isHidden = true
                self.tapSwipeIconImage.image = UIImage(named: "Swipe")
                if let hexColorStr = selectedCard?.color {
                    let backgoundColor = UIColor.colorWithHexString(hex:hexColorStr)
                    self.view.backgroundColor = backgoundColor
                    self.navigationController?.navigationBar.tintColor = backgoundColor
                }
            })
            
           // UIView.transition(from: cardFaceImageView, to: cardBackImageView, duration: 0.7, options: [.transitionCrossDissolve], completion: (Bool) in {} )
        }
        cardShowing = !cardShowing
    }
    
 

    // show the Back card
    func showCardBack() {
        titleLabel.text = ""
  //      self.tarotCardImage.image = UIImage(named: "CardBack")
        descriptionLabel.text = StringUtilities.getLocalizedString(stringKey: Constants.Strings.Main.CardBackTap)
        //self.view.backgroundColor = UIColor.init(netHex: Constants.Colors.MainBackground)

        UIView.transition(with: cardHolderView, duration: 1.2, options: [.transitionCrossDissolve], animations: { [unowned self] in
            self.cardFaceImageView.isHidden = true
            self.cardBackImageView.isHidden = false
            self.tapSwipeIconImage.image = UIImage(named: "Tap")
            self.view.backgroundColor = UIColor(netHex: Constants.Colors.MainBackground)
            self.navigationController?.navigationBar.tintColor =  UIColor(netHex: Constants.Colors.MainBackground)
            })
        self.navigationItem.title = "Change Me Prayers"
//        UIView.transition(from: cardFaceImageView, to: cardBackImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
    }
    
    func animateCard(count:Int, direction: UISwipeGestureRecognizerDirection) -> TarotCard? {
        currentCard = UInt32(count)
        if let selectedTarotCard = deckOfCards.cards?[count] {
//            UIView.animate(withDuration: 0.7,
//                           animations: {
//                            if let hexColorStr = selectedTarotCard.color {
//                                self.view.backgroundColor = UIColor.colorWithHexString(hex:hexColorStr)
//                            }
//                            self.cardFaceImageView.alpha = 0.2
//                            if let imagePath = selectedTarotCard.image {
//                                print("load image: \(imagePath)")
//                                self.cardFaceImageView.image = UIImage(named: imagePath)
//                            }
//                            self.cardFaceImageView.alpha = 1
//                            if let titleText = selectedTarotCard.title {
//                                self.titleLabel.text = titleText
//                                self.navigationItem.title = titleText
//                            } else {
//                                self.titleLabel.text = ""
//                            }
//                            if let affirmationText = selectedTarotCard.affirmation {
//                                self.descriptionLabel.text = affirmationText
//                            } else {
//                                self.descriptionLabel.text = ""
//                            }
//                            
//                },
//                           completion: nil)
            let flipDirection = (direction == UISwipeGestureRecognizerDirection.right) ? UIViewAnimationOptions.transitionFlipFromLeft : UIViewAnimationOptions.transitionFlipFromRight
            UIView.transition(with: cardFaceImageView, duration: 0.7, options: [flipDirection], animations: { [unowned self] in
//                self.cardFaceImageView.isHidden = false
//                self.cardBackImageView.isHidden = true
//                if let hexColorStr = selectedCard?.color {
//                    self.view.backgroundColor = UIColor.colorWithHexString(hex:hexColorStr)
//                }
                                                if let hexColorStr = selectedTarotCard.color {
                                                    self.view.backgroundColor = UIColor.colorWithHexString(hex:hexColorStr)
                                                    self.navigationController?.navigationBar.tintColor =  UIColor.colorWithHexString(hex:hexColorStr)
                                                }
                                                self.cardFaceImageView.alpha = 0.2
                                                if let imagePath = selectedTarotCard.image {
                                                    print("load image: \(imagePath)")
                                                    self.cardFaceImageView.image = UIImage(named: imagePath)
                                                }
                                                self.cardFaceImageView.alpha = 1
                                                self.cardBackImageView.isHidden = true
                                                if let titleText = selectedTarotCard.title {
                                                    self.titleLabel.text = titleText
                                                    self.navigationItem.title = titleText
                                                } else {
                                                    self.titleLabel.text = ""
                                                }
//                                                if let affirmationText = selectedTarotCard.affirmation {
//                                                    self.descriptionLabel.text = affirmationText
//                                                } else {
//                                                    self.descriptionLabel.text = ""
//                                                }
                })
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
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        playDrawSound()
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                
                if (currentCard > 0) {
                    currentCard -= 1
                } else {
                    currentCard = cardCount - 1
                }
                animateCard(count: Int(currentCard), direction: swipeGesture.direction)
                
                //change view controllers
            case UISwipeGestureRecognizerDirection.left :
                print("Swiped Left")
                
                let cardCount :UInt32 = deckOfCards.cards != nil ? UInt32(deckOfCards.cards!.count) : 0
                if (currentCard <  cardCount - 1) {
                    currentCard += 1
                } else {
                    currentCard = 1
                }
                animateCard(count: Int(currentCard), direction: swipeGesture.direction)
            default:
                break
            }
        }
    }
    

    func translationExceedsBounds(translation:CGPoint) -> Bool {
        if translation.x > 0 {
            return translation.x > 100
        } else if (translation.x < 0) {
            return translation.x < 100
        }
        return false
    }
    
    func respondToPanGesture(gesture:UIPanGestureRecognizer) {

        let location = gesture.location(in: self.view)
        if location.x >= self.view.frame.size.width {
            print("Next Card")
        }
        let translation : CGPoint = gesture.translation(in: self.cardBackImageView)
        print("Translation: \(translation) cardState: \(cardState)")
        if (cardState != .animating) {
            print("MOVE cardFaceImageView.center = \(cardFaceImageView.center)")
            cardFaceImageView.center = CGPoint(x:  translation.x + (startLocation?.x)!, y: (startLocation?.y)!)
        }
        if (cardState == .dragging && gesture.state == UIGestureRecognizerState.ended) {
        //    animateBack()
            cardState = .initial
        }
        if (cardState == .dragging && translationExceedsBounds(translation: translation)) {   // if we exceed a certain threshold
            if (translation.x > 0) {
                if (currentCard <  cardCount - 1) {
                    currentCard += 1
                } else {
                    currentCard = 0
                }
            } else {
                if (currentCard > 0) {
                    currentCard -= 1
                } else {
                    currentCard = cardCount - 1
                }
                
            }
            
            
            animateOff(translation:translation)
        } else {
            cardState = .dragging
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
    
    
    // animate card back to its original position
    func animateOff(translation:CGPoint)
    {
        cardFaceImageView.removeGestureRecognizer(panGestureRecognizer!)
        var frameOffscreen : CGRect = cardStartRect!    // start with original card frame
        if (translation.x > 0) {
            frameOffscreen.origin.x += 200
        } else {
            frameOffscreen.origin.x -= 200
        }
//        if (translation.y > 0) {
//            frameOffscreen.origin.y += translation.y/translation.x * UIScreen.main.bounds.size.width
//        } else {
//            frameOffscreen.origin.y -= translation.y/translation.x * UIScreen.main.bounds.size.width
//        }
        cardState = .animating
        UIView.animate(withDuration: 2, delay: 0, animations: {
                print("Moving offscreen to: \(frameOffscreen)")
                self.cardFaceImageView!.frame = frameOffscreen
            }, completion: { finished in
                print("Tarot card off Screen")
                if (finished) {
                //    self.cardFaceImageView.isHidden = true
                    print("animation FINISHED move back to \(self.cardStartRect)")
                    self.cardFaceImageView.frame = self.cardStartRect!
                    self.setCard(count: Int(self.currentCard))
                 //   self.cardFaceImageView.isHidden = false
                    self.cardState = .initial
                    self.cardFaceImageView.addGestureRecognizer(self.panGestureRecognizer!)
                }
        })
        
    }
    
   
    
    
    @IBAction func onShare(_ sender: AnyObject) {
        
        print("share")
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            facebookSheet.setInitialText("Tosha Silver's Change me Prayer Oracle App provided me with this message from the Divine")
//            facebookSheet.add(self.cardFaceImageView.image)
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onEmailShare(_ sender: AnyObject) {
        shareViaEmail()
    }
    
    func shareViaEmail() {
        var imageName = ""
        if let selectedTarotCard = deckOfCards.cards?[Int(currentCard)] {
            imageName = selectedTarotCard.image!
        }
        let configuredEmailComposer = emailComposer.configuredMailComposeViewController(imageName: imageName)
        if emailComposer.canSendMail() {
            present(configuredEmailComposer, animated: true, completion: {
                //self.navigationController?.navigationBar.barTintColor = UIColor.trainsweetGreen()
                //     UINavigationBar.appearance().backgroundColor = UIColor.trainsweetGreen()
                //                configuredEmailComposer.navigationBar.barTintColor = UIColor.trainsweetGreen()
                //                configuredEmailComposer.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.trainsweetGreen()]
                }
            )
        } else {
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
    }

    @IBAction func onRightBarClick(_ sender: AnyObject) {
        if (cardShowing) {
            shareViaEmail()
        } else {
            performSegue(withIdentifier: "instructionSegue", sender: self)
        }
    }
    

}

