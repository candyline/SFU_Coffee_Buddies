//
//  ProfileSetupViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-10-29.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//

import UIKit
//import DLRadioButton

class ProfileSetupViewController: UIViewController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate,
                                  UITextFieldDelegate,
                                  UITextViewDelegate{

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var interestTextField: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    var name = ""
    var gender = ""
    var interest = ""
    var bio = ""
    var busRoute = ""
    var major = ""
    var array = ["135", "143", "144" ,"145"]
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBAction func selectProfilePictureTapped(_ sender: AnyObject)
    {
        let iPickerController = UIImagePickerController()
        iPickerController.delegate = self
        iPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(iPickerController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the border and color of the text view
        interestTextField.layer.cornerRadius = 8.0
        interestTextField.layer.borderColor = UIColor.black.cgColor
        interestTextField.layer.borderWidth = 0.8
        
        bioTextView.layer.cornerRadius = 8.0
        bioTextView.layer.borderColor = UIColor.black.cgColor
        bioTextView.layer.borderWidth = 0.8
        
        nameTextField.delegate = self
        interestTextField.delegate = self
        bioTextView.delegate = self
        
        let myGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileSetupViewController.tappedAwayFunction(sender:)))
        self.view.addGestureRecognizer(myGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    
    @IBAction func switched(_ sender: UISegmentedControl) {
        switch SegmentedControl.selectedSegmentIndex
        {
        case 0:
            gender = "male"
        
        case 1:
            gender = "female"
            
        default:
            break
        }
    }
    
    
    
    func tappedAwayFunction(sender: UITapGestureRecognizer)
    {
        interestTextField.resignFirstResponder()
        bioTextView.resignFirstResponder()
    }
    
    @IBAction func saveProfile(_ sender: UIBarButtonItem) {
        // Store the information on the DB
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        name = nameTextField.text!
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        interest = interestTextField.text
        bio = bioTextView.text
    }
}
