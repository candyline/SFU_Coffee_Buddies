//
//  ProfilePageViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-11-05.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//
//
//  Team : Group3Genius
//
//  Changelog:
//      -File Created and Fundamental Functions Implemented
//
//  Known Bugs:
//      - N/A

import UIKit
import Alamofire
import SwiftyJSON

class ProfilePageViewController: UIViewController {

    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var busRouteLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var interestTextView: UITextView!
    @IBOutlet weak var bioTextView: UITextView!

    func getUserProfile(urlPath: String, userEmail: String, completionHandler: ((UIBackgroundFetchResult) -> Void)!)
    {
        var userFound = false
        Alamofire.request(urlPath).responseJSON
        {
            response in
            //Testing if data available for grab
            switch response.result
            {
            case .success:
                print("Able to connect to server and data found (getUserProfile)")
                //Parsing the data taken from server
                let dataBaseArray = JSON(response.result.value!)
                    
                //Searching for the user provided Email inside the JSON file from database
                for index in 0 ... dataBaseArray.count
                {
                    if let email  = dataBaseArray[index]["email"].string
                    {
                        if email == userProfile.email
                        {
                            print("Loading user information in to location memory")
                            ShakePage().getDatafromServer(localProfile: &userProfile, dataBaseArray: dataBaseArray, index : index)
                                    completionHandler(UIBackgroundFetchResult.newData)
                            userFound = true
                        }
                    }
                }
                if !(userFound)
                {
                    print("Unable to find user provided email in database (getUserProfile)")
                    print("Please create a new profile (getUserProfile)")
                }

            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    // viewDidLoad function, anyhting that needs to be declared or initialized before the view loads is done here
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Getting user information from database
        self.getUserProfile(urlPath: serverprofile, userEmail: userProfile.email, completionHandler:
            {
                (UIBackgroundFetchResult) -> Void in
                // Assign the labels on the view as the values saved from database
                self.nameLabel.text = userProfile.username
                self.busRouteLabel.text = userProfile.bus
                self.genderLabel.text = userProfile.gender
                self.majorLabel.text = userProfile.major
                
                self.interestTextView.isEditable = false
                self.bioTextView.isEditable = false
            
                self.interestTextView.text = userProfile.interest
                self.bioTextView.text = userProfile.bio
                
                if !(userProfile.image.isEmpty || userProfile.image == "0")
                {
                    self.profileImage.image = ProfileSetupViewController().stringToImage(userString: userProfile.image)
                }
                
                //self.profileImage.image = globalpicture
                print("User profile ready for display")
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
