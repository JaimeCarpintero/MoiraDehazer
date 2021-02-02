//
//  ImageUitls.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021
//  jaime.carpintero@uabc.edu.mx

import Foundation

let channelRGB: Int = 3
let channelRGBA: Int = 4

class ImageDispatcher
{
    func dispatchImageFunction(imageBuffer: ImageBuffer<Float>,
                               samplerFunction: @escaping (_ myImageData: ImageBufferData<Float>, _ rgbIndex: Int) -> Void)
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
        let imageData: ImageBufferData<Float> = imageBuffer.data()
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
                            imageData[rgbIndex] = 0.85
                            imageData[rgbIndex + 1] = 0.55
                            imageData[rgbIndex + 2] = 0.45
                            imageData[rgbIndex + 3] = 1.0
                        }else if(index == 2){
                            imageData[rgbIndex] = 0.2
                            imageData[rgbIndex + 1] = 0.3
                            imageData[rgbIndex + 2] = 0.5
                            imageData[rgbIndex + 3] = 1.0
                        }else{
                            imageData[rgbIndex] = 0.0
                            imageData[rgbIndex + 1] = 0.0
                            imageData[rgbIndex + 2] = 1.0
                            imageData[rgbIndex + 3] = 1.0
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
    
    func doSomething(imageData: ImageBufferData<Float>, rgbIndex: Int){
        imageData[rgbIndex] = 0.5
        imageData[rgbIndex + 1] = 0.75
        imageData[rgbIndex + 2] = 0.5
        imageData[rgbIndex + 3] = 1.0
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
