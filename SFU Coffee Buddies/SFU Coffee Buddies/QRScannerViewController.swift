//  File Name: QRScannerViewController.swift
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
import AVFoundation
import Alamofire
import SwiftyJSON

//Class for QRCode scanning using camera
//Author: Daniel Tan
//Last Modify: Dec 2,2016
//Known Bugs: none
class QRScannerViewController: UIViewController,
                               AVCaptureMetadataOutputObjectsDelegate{

    // Variables and Outlets
    @IBOutlet weak var promptlbl: UITextView!
    @IBOutlet weak var lblQRCodeLabel: UILabel!
    @IBOutlet weak var lblQRCodeResult: UILabel!
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    //Initilize the page when user enter the page
    //Author: Daniel Tan
    //Last Modify: Dec 2,2016
    //Known Bugs: none
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
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

    func configureVideoCapture()
    {
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }

    
    func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
    }
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.red.cgColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubview(toFront: vwQRCode!)
    }
    
    // Delegate handling function
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            lblQRCodeResult.text = "NO QRCode text detected"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode
        {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil
            {
                lblQRCodeResult.text = objMetadataMachineReadableCodeObject.stringValue
            }
            
            // Do check with database here
            let appendedUrl = serverprofile + targetprofile.id
            Alamofire.request(appendedUrl).responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
                        print("Grabbed data from database")
                        let dataBaseArray = JSON(response.result.value!)
                        ShakePage().getDatafromServer(localProfile: &targetprofile, dataBaseArray: dataBaseArray, index: 0)
                        
                        if self.lblQRCodeResult.text == targetprofile.qrCode
                        {
                            userprofile.coffee += 1
                        }
                        
                    case . failure(let error):
                        print(error)
                        print("unable to grab data from database")
                    }

            }
        }
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
