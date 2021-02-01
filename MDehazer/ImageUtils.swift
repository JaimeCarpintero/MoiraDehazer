//
//  ImageUitls.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021

import Foundation

let channelRGB: Int = 3
let channelRGBA: Int = 4

class ImageDispatcher
{
    func dispatchImageFunction(imageBuffer: ImageBuffer,
                               samplerFunction: @escaping (_ myImageData: ImageBufferData<UInt8>, _ rgbIndex: Int) -> Void)
    {
        let width: Int = imageBuffer.width()
        let height: Int = imageBuffer.height()
        
        let numberOfDispatchers: Int = 4
        var regions : [ImageRegion] = []
        let heightPartition = height / numberOfDispatchers
        let heightResidue: Int = height % numberOfDispatchers
        
        for index in 0..<numberOfDispatchers{
            let top = (index * heightPartition)
            var bottom = top + heightPartition
            if(index == numberOfDispatchers - 1){
                bottom = bottom + heightResidue
            }
            regions.append(ImageRegion(top: top, bottom: bottom, left: 0, right: width))
        }
        
        let channels = imageBuffer.channels()
        let imageData: ImageBufferData<UInt8> = imageBuffer.data()
        let dispatchGroup: DispatchGroup = DispatchGroup()
        
        for index in 0..<(regions.count){
            dispatchGroup.enter()
            DispatchQueue.global(qos: .background).async{
                let region: ImageRegion = regions[index]
                for row in region.top..<region.bottom{
                    for col in region.left..<region.right{
                        let rgbIndex = (row * width + col) * channels
                        if(index == 0){
                            samplerFunction(imageData, rgbIndex)
                        }else if(index == 1){
                            imageData[rgbIndex] = 200
                            imageData[rgbIndex + 1] = 125
                            imageData[rgbIndex + 2] = 100
                            imageData[rgbIndex + 3] = 255
                        }else if(index == 2){
                            imageData[rgbIndex] = 50
                            imageData[rgbIndex + 1] = 50
                            imageData[rgbIndex + 2] = 100
                            imageData[rgbIndex + 3] = 255
                        }else{
                            imageData[rgbIndex] = 0
                            imageData[rgbIndex + 1] = 0
                            imageData[rgbIndex + 2] = 255
                            imageData[rgbIndex + 3] = 255
                        }
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .global()){
            print("Finished work")
        }
        dispatchGroup.wait()
        
    }
    
    func doSomething(imageData: ImageBufferData<UInt8>, rgbIndex: Int){
        imageData[rgbIndex] = 125
        imageData[rgbIndex + 1] = 200
        imageData[rgbIndex + 2] = 100
        imageData[rgbIndex + 3] = 255
    }

    
    private struct ImageRegion{
        init(top: Int, bottom: Int, left: Int, right: Int) {
            self.top = top
            self.bottom = bottom
            self.left = left
            self.right = right
        }
        init() {
            top = 0
            bottom = 0
            left = 0
            right = 0
        }
        var top: Int
        var bottom: Int
        var left: Int
        var right: Int
    }
    
}
