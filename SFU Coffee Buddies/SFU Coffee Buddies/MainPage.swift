//
//  File Name: ShakePage.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Daniel Tan
//  Creation Date: Oct 28, 2016
//  List of Changes:
//  V1.0: Created by Daniel Tan
//  V1.1: default server address added
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Nov 6, 2016
//
//  List of Bugs: none
//
//  Copyright © 2016 Daniel Tan. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

//Default Server Address (localhost)
//let serverprofile = "http://127.0.0.1:8080/messages/"
let serverprofile = "http://guarded-shore-21847.herokuapp.com/contacts/"
//let serverabuse = "http://127.0.0.1:8080/reportAbuse/"
let serverabuse = "http://guarded-shore-21847.herokuapp.com/reportAbuse"
//This classs is the main manual of the app
//Author: Eton Kan
//Last Modifty: Nov 6,2016
class MainPage: UIViewController
{
    @IBOutlet weak var rewardProgramLabel: UILabel!
    @IBOutlet weak var starYellowOne: UIImageView!
    @IBOutlet weak var starYellowTwo: UIImageView!
    @IBOutlet weak var starYellowThree: UIImageView!
    @IBOutlet weak var starYellowFour: UIImageView!
    @IBOutlet weak var starYellowFive: UIImageView!
    @IBOutlet weak var starBlackOne: UIImageView!
    @IBOutlet weak var starBlackTwo: UIImageView!
    @IBOutlet weak var starBlackThree: UIImageView!
    @IBOutlet weak var starBlackFour: UIImageView!
    @IBOutlet weak var starBlackFive: UIImageView!
    @IBOutlet weak var redeemCoffeeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var redeemCoffeeDisplay: UILabel!
    @IBOutlet weak var coffeeCodeDisplay: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        rewardProgramLabel.isHidden = false
        redeemCoffeeDisplay.isHidden = true
        redeemCoffeeButton.isHidden = true
        coffeeCodeDisplay.isHidden = true
        resetButton.isHidden = true
        
        //Times matched (from zero to five)
        self.starYellowOne.isHidden = true
        self.starYellowTwo.isHidden = true
        self.starYellowThree.isHidden = true
        self.starYellowFour.isHidden = true
        self.starYellowFive.isHidden = true
        //Times to be matched (from zero to five)
        self.starBlackOne.isHidden = true
        self.starBlackTwo.isHidden = true
        self.starBlackThree.isHidden = true
        self.starBlackFour.isHidden = true
        self.starBlackFive.isHidden = true
        
        if (userProfile.coffee == 0)
        {
            self.starYellowOne.isHidden = true
            self.starYellowTwo.isHidden = true
            self.starYellowThree.isHidden = true
            self.starYellowFour.isHidden = true
            self.starYellowFive.isHidden = true
            
            self.starBlackOne.isHidden = false
            self.starBlackTwo.isHidden = false
            self.starBlackThree.isHidden = false
            self.starBlackFour.isHidden = false
            self.starBlackFive.isHidden = false
        }
        else if (userProfile.coffee == 1)
        {
            self.starYellowOne.isHidden = false
            self.starYellowTwo.isHidden = true
            self.starYellowThree.isHidden = true
            self.starYellowFour.isHidden = true
            self.starYellowFive.isHidden = true
            
            self.starBlackOne.isHidden = true
            self.starBlackTwo.isHidden = false
            self.starBlackThree.isHidden = false
            self.starBlackFour.isHidden = false
            self.starBlackFive.isHidden = false
        }
        else if (userProfile.coffee == 1)
        {
            self.starYellowOne.isHidden = false
            self.starYellowTwo.isHidden = false
            self.starYellowThree.isHidden = true
            self.starYellowFour.isHidden = true
            self.starYellowFive.isHidden = true
            
            self.starBlackOne.isHidden = true
            self.starBlackTwo.isHidden = true
            self.starBlackThree.isHidden = false
            self.starBlackFour.isHidden = false
            self.starBlackFive.isHidden = false
        }
        else if (userProfile.coffee == 3)
        {
            self.starYellowOne.isHidden = false
            self.starYellowTwo.isHidden = false
            self.starYellowThree.isHidden = false
            self.starYellowFour.isHidden = true
            self.starYellowFive.isHidden = true
            
            self.starBlackOne.isHidden = true
            self.starBlackTwo.isHidden = true
            self.starBlackThree.isHidden = true
            self.starBlackFour.isHidden = false
            self.starBlackFive.isHidden = false
        }
        else if (userProfile.coffee == 4)
        {
            self.starYellowOne.isHidden = false
            self.starYellowTwo.isHidden = false
            self.starYellowThree.isHidden = false
            self.starYellowFour.isHidden = false
            self.starYellowFive.isHidden = true
            
            self.starBlackOne.isHidden = true
            self.starBlackTwo.isHidden = true
            self.starBlackThree.isHidden = true
            self.starBlackFour.isHidden = true
            self.starBlackFive.isHidden = false
        }
        else if (userProfile.coffee == 5)
        {
            self.starYellowOne.isHidden = false
            self.starYellowTwo.isHidden = false
            self.starYellowThree.isHidden = false
            self.starYellowFour.isHidden = false
            self.starYellowFive.isHidden = false
            
            self.starBlackOne.isHidden = true
            self.starBlackTwo.isHidden = true
            self.starBlackThree.isHidden = true
            self.starBlackFour.isHidden = true
            self.starBlackFive.isHidden = true
            
            redeemCoffeeButton.isHidden = false
        }
    }
    
    @IBAction func reset(_ sender: UIButton)
    {
        self.viewDidLoad()
    }
    //User accepted the match, remove target from queue and start chating
    //Author: Eton Kan
    //Last Modify: Nov 11,2016
    //Known Bugs: none
    @IBAction func redeemCoffee(_ sender: UIButton)
    {
        userProfile.coffeeCode = QRGeneratorViewController().randomString(length: 10)
        //User redeemed coffee
        userProfile.coffee = 0
        coffeeCodeDisplay.text = ""
        
        // Store code variable as the QR code into the database
        let appendedUserUrl = serverprofile + userProfile.id
        
        // Store the information on the DB
        let parameters: [String: Any] =
        [
                "meeting"   : userProfile.meeting,
                "gender"    : userProfile.gender,
                "pw"        : userProfile.pw, // user's password
                "email"     : userProfile.email,
                "bio"       : userProfile.bio,
                "username"  : userProfile.username,
                "interest"  : userProfile.interest,
                "bus"       : userProfile.bus,
                "major"     : userProfile.major,
                "coffee"    : userProfile.coffee,
                "blockUser" : userProfile.blockedUser,
                "QRcode"    : userProfile.qrCode,
                "image"     : userProfile.image,
                "coffeeCode": userProfile.coffeeCode
        ]
        print(parameters)
        Alamofire.request(appendedUserUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseString
            {
                response in
                print(response)
                switch response.result
                {
                case .success:
                    print("Free coffee code updated")
                    self.redeemCoffeeButton.isHidden = true
                    self.redeemCoffeeDisplay.isHidden = false
                    self.coffeeCodeDisplay.isHidden = false
                    self.coffeeCodeDisplay.text = userProfile.coffeeCode
                    self.resetButton.isHidden = false
                    
                case .failure(let error):
                    print(error)
                    print("unable to upload free coffee Code to database")
                    self.redeemCoffeeButton.isHidden = true
                    self.coffeeCodeDisplay.text = "Unable to put coffee code to server, please try again later"
                    userProfile.coffee = 5
                }
            }
    }
}
