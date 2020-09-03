//
//  ViewController.swift
//  OpenCV_IOS
//
//  Created by wang on 2020/8/21.
//  Copyright © 2020 wang. All rights reserved.
//

import UIKit
//import AVKit
import AVFoundation
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    var session = AVCaptureSession()
    var previewImage = UIImage()
    @IBOutlet weak var imageViewLive: UIImageView!
    @IBOutlet weak var redImageView: UIImageView!
    @IBOutlet weak var circleImageView: UIImageView!
    
    @IBOutlet weak var trafficSignLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startLiveVideo()
        
        sleep(1)
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.setPreviewImage), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.setRedPreviewImage), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.setCirclePreviewImage), userInfo: nil, repeats: true)
    }
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
    
    func startLiveVideo() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        session.startRunning()
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
        connection.videoOrientation = AVCaptureVideoOrientation.portrait;
        updatePreviewImage(sampleBuffer:sampleBuffer)
        
    }
    func updatePreviewImage(sampleBuffer: CMSampleBuffer){
        let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciimage : CIImage = CIImage(cvPixelBuffer: imageBuffer)
        previewImage = self.convertCIImageToUIImage(cmage: ciimage)
    }
    func convertCIImageToUIImage(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage, scale: 1.0, orientation: UIImage.Orientation.right)
        return image
    }
    func getPrediction(_ image: UIImage) {
        let model = TrafficSign()

        guard let pixelBuffer = buffer(from: image) else { return }
        guard let prediction = try? model.prediction(image: pixelBuffer) else { return }
        print("------------------")
        print(prediction.classLabel) // Most likely image category as string value
        trafficSignLabel.text = prediction.classLabel
    }
    @objc func setPreviewImage(){
        
        let image = try! OpenCVWrapper.getBinaryImage(previewImage)
        getPrediction(image)
        imageViewLive.image = image
        

    }
    @objc func setRedPreviewImage(){
        
        let image = try! OpenCVWrapper.getTrafficSign(previewImage)
        redImageView.image = image
        
    }
    @objc func setCirclePreviewImage(){
        
        let image = try! OpenCVWrapper.getCircleImage(previewImage)
        circleImageView.image = image
        
    }
}

