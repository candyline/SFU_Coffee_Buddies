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
                               AVCaptureMetadataOutputObjectsDelegate
{

    // Variables and Outlets
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var promptlbl: UITextView!
    @IBOutlet weak var lblQRCodeLabel: UILabel!
    @IBOutlet weak var lblQRCodeResult: UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    override func viewDidLoad()
    {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView
            {
                qrCodeFrameView.layer.borderColor = UIColor.blue.cgColor
                qrCodeFrameView.layer.borderWidth = 5
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        }
        catch
        {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: promptlbl)
        view.bringSubview(toFront: lblQRCodeLabel)
        view.bringSubview(toFront: lblQRCodeResult)
        view.bringSubview(toFront: navigationBar)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0
        {
            qrCodeFrameView?.frame = CGRect.zero
            lblQRCodeResult.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode
        {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil
            {
                lblQRCodeResult.text = metadataObj.stringValue
                let CodeScannedScene = self.storyboard?.instantiateViewController(withIdentifier: "scanCodeView") as! CodeScannedScene
                
                self.navigationController?.pushViewController(CodeScannedScene, animated: true)
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
