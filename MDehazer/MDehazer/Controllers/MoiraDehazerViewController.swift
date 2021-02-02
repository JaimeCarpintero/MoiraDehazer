//
//  ViewController.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021
//  jaime.carpintero@uabc.edu.mx

import UIKit

class MoiraDehazerViewController: UIViewController {

    @IBOutlet weak var dehazeImageView: UIImageView!
    
    @IBOutlet weak var dehazeFactorSlider: UIStackView!
    
    @IBOutlet weak var saturationFactorSlider: NSLayoutConstraint!
    
    private let mImagePicker: UIImagePickerController = UIImagePickerController()
    private let mDehazeAlgorithm: DarkChannelPriorAlgorithm = DarkChannelPriorAlgorithm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mImagePicker.delegate = self
        
        mImagePicker.sourceType = .photoLibrary
        mImagePicker.allowsEditing = true
    }
    
    @IBAction func onLoadImagePressed(_ sender: UIBarButtonItem) {
        //NOTE [Jaime]: Here maybe we can use the callback to start the dehazing process
        present(mImagePicker, animated: true, completion: nil)
    }
    
    func getNewImage(sourceImage: UIImage) -> UIImage{
        
            if let pickedImageCgi = sourceImage.cgImage{
                let colosrpace = CGColorSpaceCreateDeviceRGB()
                let width: Int = pickedImageCgi.width
                let height: Int = pickedImageCgi.height
                let bitsPerComponent = 8
                let bytesPerPixel = pickedImageCgi.bitsPerPixel / bitsPerComponent
                let bytesPerRow = bytesPerPixel * width
                let bitmapInfo = pickedImageCgi.bitmapInfo.rawValue
                let imageSize = width * height
                
                guard let newImageContext = CGContext(data: nil,
                                                      width: width,
                                                      height: height,
                                                      bitsPerComponent: bitsPerComponent,
                                                      bytesPerRow: bytesPerRow,
                                                      space: colosrpace,
                                                      bitmapInfo: bitmapInfo) else{
                    fatalError("Could not load image properly")
                }
                
                newImageContext.draw(pickedImageCgi, in: CGRect(x: 0, y: 0, width: width, height: height))
                
                guard let imageBuffer = newImageContext.data else{
                    fatalError("Could not retrieve data from image")
                }
                
                let inputImageBuffer: ImageBuffer<Float> = ImageBuffer<Float>(width: width,
                                                                        height: height,
                                                                        channels: channelRGBA,
                                                                        initialValue: 1.0)
                
                let outputImageBuffer: ImageBuffer<Float> = ImageBuffer<Float>(width: width,
                                                                         height: height,
                                                                         channels: channelRGBA,
                                                                         initialValue: 1.0)
                
                let floatBufferData: ImageBufferData<Float> = inputImageBuffer.data()
   
                let imageDispatcher: ImageDispatcher = ImageDispatcher()
//                imageDispatcher.dispatchImageFunction(imageBuffer: buffer,
//                                                      samplerFunction: imageDispatcher.doSomething(imageData:rgbIndex:))
                
                let configuration = DarkChannelPriorConfiguration(width: width,
                                                                  height: height,
                                                                  isAlphaPresent: true,
                                                                  windowSize: 15,
                                                                  wHazeFactor: 0.95)
                mDehazeAlgorithm.apply(configuration: configuration,
                                       input: inputImageBuffer,
                                       output: outputImageBuffer)
                
                
                let imageDataBuffer = imageBuffer.bindMemory(to: UInt8.self, capacity: imageSize * bytesPerPixel)
                
                for index in 0..<imageSize{
                    let rgbaIndex = index * bytesPerPixel
                    imageDataBuffer[rgbaIndex] = UInt8(floatBufferData[rgbaIndex] * 255)
                    imageDataBuffer[rgbaIndex + 1] = UInt8(floatBufferData[rgbaIndex + 1] * 255)
                    imageDataBuffer[rgbaIndex + 2] = UInt8(floatBufferData[rgbaIndex + 2] * 255)
                    imageDataBuffer[rgbaIndex + 3] = UInt8(floatBufferData[rgbaIndex + 3] * 255)
                }
                
                let outputCGImage = newImageContext.makeImage()!
                let outputImage = UIImage(cgImage: outputCGImage, scale: sourceImage.scale, orientation: sourceImage.imageOrientation)
                return outputImage
            }
            return sourceImage
    }
    
}

//MARK: -Extensions

extension MoiraDehazerViewController: UINavigationControllerDelegate{
}

extension MoiraDehazerViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let imagePickedByUser = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            dehazeImageView.image = getNewImage(sourceImage: imagePickedByUser)
        }
        mImagePicker.dismiss(animated: true, completion: nil)
    }
}

