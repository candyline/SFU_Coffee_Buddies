//  File Name: ProfilePageViewController.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Daniel Tan
//  Creation Date: Oct 29, 2016
//
//  Changelog:
//      V1.0: File Created and Fundamental Functions Implemented
//      V1.1: Grabbing data from database implemented
//      V1.2: user profile pictures from database implemented
//
//  Last Modified Author: Eton Kan
//  Last Modified Date: Dec 2, 2016
//
//  List of Bugs:
//      - N/A
//
//  Copyright © 2016 CMPT275-3. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON

class ProfilePageViewController: UIViewController
{
    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var busRouteLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var interestTextView: UITextView!
    @IBOutlet weak var bioTextView: UITextView!

    //Getting user's information for display later
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
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
                        if email == userprofile.email
                        {
                            print("Loading user information in to location memory")
                            ShakePage().getDatafromServer(localProfile: &userprofile, dataBaseArray: dataBaseArray, index : index)
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
    // viewDidLoad function, anything that needs to be declared or initialized before the view loads is done here
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    override func viewDidLoad()
    {
        //making profile pic circular
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        super.viewDidLoad()
        //Getting user information from database
        self.getUserProfile(urlPath: serverprofile, userEmail: userprofile.email, completionHandler:
        {
            (UIBackgroundFetchResult) -> Void in
            // Assign the labels on the view as the values saved from database
            self.nameLabel.text = userprofile.username
            self.busRouteLabel.text = userprofile.bus
            self.genderLabel.text = userprofile.gender
            self.majorLabel.text = userprofile.major
                
            self.interestTextView.isEditable = false
            self.bioTextView.isEditable = false
            
            self.interestTextView.text = userprofile.interest
            self.bioTextView.text = userprofile.bio
            
            if !(userprofile.image.isEmpty || userprofile.image == "0")
            {
                self.profileImage.image = ProfileSetupViewController().stringToImage(userString: userprofile.image)
            }
                
            //self.profileImage.image = globalpicture
            print("User profile ready for display")
        })
    }
    
    //For error handling
    //Author: Eton Kan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
