//  File Name: QRGeneratorViewController.swift
//  Project Name: SFU Coffee Buddies
//  Team Name: Group3Genius (G3G)
//  Author: Daniel Tan
//  Creation Date: Nov 20, 2016
//
//  Changelog:
//      V1.0: File Created and Fundamental Functions Implemented
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

//Class for generating random QRCodes for matching
//Author: Daniel Tan
//Last Modify: Dec 2,2016
//Known Bugs: none
class QRGeneratorViewController: UIViewController
{
    
    // Variables and outlets-
    var qrcodeImage: CIImage!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    //Initilize the page when user enter the page
    //Author: Daniel Tan
    //Last Modify: Dec 2,2016
    //Known Bugs:
    //  1)Haven't save it to user targetProfile yet
    //  2)Need chat function to determine how to save it
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Generate and put the QR code on the screen when the view loads
        if qrcodeImage == nil
        {
            let code = randomString(length: 5)
            userprofile.qrCode = code
            // Store code variable as the QR code into the database
            let appendedUserUrl = serverprofile + userprofile.id
            Alamofire.request(appendedUserUrl).responseJSON
                {
                    response in
                    //Testing if data available for grab
                    switch response.result
                    {
                    case .success:
                        print("Data Found")
                    case .failure(let error):
                        print(error)
                        print("Cannot get data from server")
                        return
                    }
                    
                    //Parsing the data taken from server
                    let dataBaseArray = JSON(response.result.value!)
                    
                    //Search the user inside the JSON
                    ShakePage().getDatafromServer(localProfile: &userprofile, dataBaseArray: dataBaseArray, index : 0)
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
                    //print(parameters)
                    //Uploading updated user info to database
                    Alamofire.request(appendedUserUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                        .responseString
                    {
                        response in
                        print(response)
                        print("QRcode uploaded")
                        
                        let data = code.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
                        
                        let filter = CIFilter(name: "CIQRCodeGenerator")
                        
                        filter?.setValue(data, forKey: "inputMessage")
                        filter?.setValue("Q", forKey: "inputCorrectionLevel")
                        
                        self.qrcodeImage = filter?.outputImage
                        
                        //QRCodeImage.image = UIImage(ciImage: qrcodeImage)
                        self.displayQRCodeImage()
                    }
            }
        }
    }

    //For error handling
    //Author: Daniel Tan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeImageViewScale(_ sender: AnyObject)
    {
        QRCodeImage.transform = CGAffineTransform(scaleX: CGFloat(sizeSlider.value), y: CGFloat(sizeSlider.value))
    }
    
    // Purpose : Rectifies the image so that the QR code is not blurry
    func displayQRCodeImage() {
        let scaleX = QRCodeImage.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = QRCodeImage.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        QRCodeImage.image = UIImage(ciImage: transformedImage)
        
        
    }
    
    // Purpose : Random code generator, used to randomly produce QR Codes
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
