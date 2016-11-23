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
    @IBOutlet weak var freeCoffeeLabel: UILabel!
    @IBOutlet weak var starOne: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        rewardProgramLabel.isHidden = false
        freeCoffeeLabel.isHidden = true
        
        if (userProfile.coffee == "0")
        {
            self.starOne.isHidden = true
            self.starTwo.isHidden = true
            self.starThree.isHidden = true
            self.starFour.isHidden = true
            self.starFive.isHidden = true
        }
        else if (userProfile.coffee == "1")
        {
            self.starOne.isHidden = false
            self.starTwo.isHidden = true
            self.starThree.isHidden = true
            self.starFour.isHidden = true
            self.starFive.isHidden = true
        }
        else if (userProfile.coffee == "2")
        {
            self.starOne.isHidden = false
            self.starTwo.isHidden = false
            self.starThree.isHidden = true
            self.starFour.isHidden = true
            self.starFive.isHidden = true
        }
        else if (userProfile.coffee == "3")
        {
            self.starOne.isHidden = false
            self.starTwo.isHidden = false
            self.starThree.isHidden = false
            self.starFour.isHidden = true
            self.starFive.isHidden = true
        }
        else if (userProfile.coffee == "4")
        {
            self.starOne.isHidden = false
            self.starTwo.isHidden = false
            self.starThree.isHidden = false
            self.starFour.isHidden = false
            self.starFive.isHidden = true
        }
        else if (userProfile.coffee == "5")
        {
            self.starOne.isHidden = false
            self.starTwo.isHidden = false
            self.starThree.isHidden = false
            self.starFour.isHidden = false
            self.starFive.isHidden = false
            self.freeCoffeeLabel.isHidden = false
        }
    }
}
