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

class ProfilePageViewController: UIViewController {

    // Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var busRouteLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var interestTextView: UITextView!
    @IBOutlet weak var bioTextView: UITextView!
    
    // viewDidLoad function, anyhting that needs to be declared or initialized before the view loads is done here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the labels on the view as the values saved from the ProfileSetupViewController
        nameLabel.text = globalname
        busRouteLabel.text = globalbusroute
        genderLabel.text = globalgender
        majorLabel.text = globalmajor
        
        interestTextView.isEditable = false
        bioTextView.isEditable = false
        
        interestTextView.text = globalinterest
        bioTextView.text = globalbio
        
        profileImage.image = globalpicture

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
