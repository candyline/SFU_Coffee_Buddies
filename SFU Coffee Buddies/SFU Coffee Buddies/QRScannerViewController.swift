//
//  QRScannerViewController.swift
//  SFU Coffee Buddies
//
//  Created by Daniel Tan on 2016-11-13.
//  Copyright © 2016 CMPT275-3. All rights reserved.
//
//  Team : Group3Genius
//
//  Changelog:
//      -File Created and Fundamental Functions Implemented

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class QRScannerViewController: UIViewController,
                               AVCaptureMetadataOutputObjectsDelegate{

    // Variables and Outlets
    @IBOutlet weak var promptlbl: UITextView!
    @IBOutlet weak var lblQRCodeLabel: UILabel!
    @IBOutlet weak var lblQRCodeResult: UILabel!
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
        
    }

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
            let appendedUrl = serverprofile + targetProfile.id
            Alamofire.request(appendedUrl).responseJSON
                {
                    response in
                    switch response.result
                    {
                    case .success:
                        print("Grabbed data from database")
                        let dataBaseArray = JSON(response.result.value!)
                        ShakePage().getDatafromServer(localProfile: &targetProfile, dataBaseArray: dataBaseArray, index: 0)
                        
                        if self.lblQRCodeResult.text == targetProfile.qrCode
                        {
                            userProfile.coffee += 1
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
