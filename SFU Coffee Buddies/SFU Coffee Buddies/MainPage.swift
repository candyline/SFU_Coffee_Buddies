//  File Name: MainPage.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Daniel Tan
//  Creation Date: Oct 28, 2016
//  List of Changes:
//  V1.0: Created by Daniel Tan
//  V1.1: default server address added
//  V1.2: Reward Program added
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Dec 2, 2016
//
//  List of Bugs: none
//
//  Copyright © 2016 Daniel Tan. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

//Default Server Address
let serverprofile = "http://guarded-shore-21847.herokuapp.com/contacts/"
let serverabuse = "http://guarded-shore-21847.herokuapp.com/reportAbuse"

//This classs contains: 
//  1) Logout
//  2) Reward Program
//Author: Eton Kan
//Last Modifty: Dec 2,2016
class MainPage: UIViewController
{
    //Yellow stars for matched with QRCode
    //Black stars for matched needed to redeem free coffee
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
    
    //Initilize the page when user enter the page
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
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
        
        //Turning on stars depend on the number of match made
        if (userprofile.coffee == 0)
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
        else if (userprofile.coffee == 1)
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
        else if (userprofile.coffee == 1)
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
        else if (userprofile.coffee == 3)
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
        else if (userprofile.coffee == 4)
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
        else if (userprofile.coffee == 5)
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
            
            //User matched five times, about to redeem free coffee
            redeemCoffeeButton.isHidden = false
        }
    }
    
    //Reset global variable that uses Profile struct when logout
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    func resetProfile(localProfile: inout Profile)
    {
        localProfile.id = "0"
        localProfile.meeting = "0"
        localProfile.pw = "0"
        localProfile.username = "0"
        localProfile.bio = "0"
        localProfile.interest = "0"
        localProfile.email = "0"
        localProfile.bus = "0"
        localProfile.major = "0"
        localProfile.blockedUser.removeAll()
        localProfile.qrCode = "0"
        localProfile.image = "0"
        localProfile.coffee = 0
        localProfile.coffeeCode = "0"
    }
    
    //User logout of the app and delete all user info stored
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    @IBAction func logout(_ sender: UIButton)
    {
        self.resetProfile(localProfile: &userprofile)
        self.resetProfile(localProfile: &targetprofile)
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "loginPage"))! as UIViewController
        self.present(vc, animated:true, completion: nil)
    }
    
    //After redeeming coffee, user will be reset to zero yellow stars
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    @IBAction func reset(_ sender: UIButton)
    {
        self.viewDidLoad()
    }
    
    //Redeem and upload coffee code to server for record
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    @IBAction func redeemCoffee(_ sender: UIButton)
    {
        userprofile.coffeeCode = QRGeneratorViewController().randomString(length: 10)
        //User redeemed coffee
        userprofile.coffee = 0
        coffeeCodeDisplay.text = ""
        
        // Store code variable as the QR code into the database
        let appendedUserUrl = serverprofile + userprofile.id
        
        // Store the information on the DB
        let parameters: [String: Any] =
        [
                "meeting"   : userprofile.meeting,
                "gender"    : userprofile.gender,
                "pw"        : userprofile.pw, // user's password
                "email"     : userprofile.email,
                "bio"       : userprofile.bio,
                "username"  : userprofile.username,
                "interest"  : userprofile.interest,
                "bus"       : userprofile.bus,
                "major"     : userprofile.major,
                "coffee"    : userprofile.coffee,
                "blockUser" : userprofile.blockedUser,
                "QRcode"    : userprofile.qrCode,
                "image"     : userprofile.image,
                "coffeeCode": userprofile.coffeeCode
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
                    self.coffeeCodeDisplay.text = userprofile.coffeeCode
                    self.resetButton.isHidden = false
                    
                case .failure(let error):
                    print(error)
                    print("unable to upload free coffee Code to database")
                    self.redeemCoffeeButton.isHidden = true
                    self.coffeeCodeDisplay.text = "Unable to put coffee code to server, please try again later"
                    userprofile.coffee = 5
                }
            }
    }
}
