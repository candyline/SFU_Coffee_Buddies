//
//  QRGeneratorViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-11-13.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//
//
//  Team : Group3Genius
//
//  Changelog:
//      -File Created and Fundamental Functions Implemented


import UIKit
import Alamofire
import SwiftyJSON

class QRGeneratorViewController: UIViewController
{
    
    // Variables and outlets-
    var qrcodeImage: CIImage!
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    
    
    //Haven't save it to user targetProfile yet
    //Need chat function to determine how to save it
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Generate and put the QR code on the screen when the view loads
        if qrcodeImage == nil
        {
            let code = randomString(length: 10)
            userProfile.qrCode = code
            print("I am generated qrCode")
            print(code)
            print("I am qrCode in userProfile")
            print(userProfile.qrCode)
            print(userProfile.email)
            // Store code variable as the QR code into the database
            let appendedUserUrl = serverprofile + userProfile.id
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
                    ShakePage().getDatafromServer(localProfile: &userProfile, dataBaseArray: dataBaseArray, index : 0)
                    // Store the information on the DB
                    let parameters: [String: Any] =
                    [
                            "meeting"  : userProfile.meeting,
                            "gender"   : userProfile.gender,
                            "pw"       : userProfile.pw, // user's password
                            "email"    : userProfile.email,
                            "bio"      : userProfile.bio,
                            "username" : userProfile.username,
                            "interest" : userProfile.interest,
                            "bus"      : userProfile.bus,
                            "major"    : userProfile.major,
                            "coffee"   : userProfile.coffee,
                            "blockUser": userProfile.blockedUser,
                            "QRcode"   : userProfile.qrCode,
                            "image"    : userProfile.image
                    ]
                    print(parameters)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
