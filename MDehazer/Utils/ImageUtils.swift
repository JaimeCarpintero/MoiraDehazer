//
//  ImageUitls.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021
//  jaime.carpintero.carrillo@gmail.com

import Foundation

let channelRGB: Int = 3
let channelRGBA: Int = 4

class ImageDispatcher
{
    func dispatchtDehazeFunction(imageBuffer: ImageBuffer<Float>,
                                 outputBuffer: ImageBuffer<Float>,
                                 transmissionMap: BufferData<Float>,
                                 ambientLightR: Float,
                                 ambientLightG: Float,
                                 ambientLightB: Float,
                                 samplerFunction: @escaping (_ input: BufferData<Float>,
                                                             _ output: BufferData<Float>,
                                                             _ transmissionMap: BufferData<Float>,
                                                             _ index: Int,
                                                             _ channels: Int,
                                                             _ ambientLightR: Float,
                                                             _ ambientLightG: Float,
                                                             _ ambientLightB: Float) -> Void)
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
        let imageData: BufferData<Float> = imageBuffer.data()
        let outputData: BufferData<Float> = outputBuffer.data()
        let dispatchGroup: DispatchGroup = DispatchGroup()
        
        for index in 0..<(regions.count){
            dispatchGroup.enter()
            DispatchQueue.global(qos: .background).async{
                let region: ImageRegion = regions[index]
                for row in region.top..<region.bottom{
                    for col in region.left..<region.right{
                        
                        let rgbaIndex = (row * width + col)
                        samplerFunction(imageData,
                                        outputData,
                                        transmissionMap,
                                        rgbaIndex,
                                        channels,
                                        ambientLightR,
                                        ambientLightG,
                                        ambientLightB)
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .global()){
            print("Finishing dehazing process")
        }
        print("Starting dehazing process")
        dispatchGroup.wait()
        
    }
    
    
    func dispatchTransmissionMapFunction(imageBuffer: ImageBuffer<Float>,
                                         transmissionMap: BufferData<Float>,
                                         windowSize: Int,
                                         ambientLightR: Float,
                                         ambientLightG: Float,
                                         ambientLightB: Float,
                                         wHazeFactor: Float,
                                         samplerFunction: @escaping (_ myImageData: BufferData<Float>,
                                                                     _ transmissionMap: BufferData<Float>,
                                                                     _ index: Int,
                                                                     _ width: Int,
                                                                     _ height: Int,
                                                                     _ channels: Int,
                                                                     _ windowSize: Int,
                                                                     _ ambientLightR: Float,
                                                                     _ ambientLightG: Float,
                                                                     _ ambientLightB: Float,
                                                                     _ wHazeFactor: Float) -> Void)
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
        let imageData: BufferData<Float> = imageBuffer.data()
        let dispatchGroup: DispatchGroup = DispatchGroup()
        
        for index in 0..<(regions.count){
            dispatchGroup.enter()
            DispatchQueue.global(qos: .background).async{
                let region: ImageRegion = regions[index]
                for row in region.top..<region.bottom{
                    for col in region.left..<region.right{
                        
                        let rgbaIndex = (row * width + col)
                        samplerFunction(imageData,
                                        transmissionMap,
                                        rgbaIndex,
                                        width,
                                        height,
                                        channels,
                                        windowSize,
                                        ambientLightR,
                                        ambientLightG,
                                        ambientLightB,
                                        wHazeFactor)
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .global()){
            print("Finishing transmission map generation")
        }
        print("Starting transmission map generation")
        dispatchGroup.wait()
        
    }
    
    func dispatchImageFunction(imageBuffer: ImageBuffer<Float>,
                               samplerFunction: @escaping (_ myImageData: BufferData<Float>,
                                                           _ rgbIndex: Int) -> Void)
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
        let imageData: BufferData<Float> = imageBuffer.data()
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
    
    func normalizeImage(bufferToNormalize: UnsafeMutablePointer<UInt8>,
                        normalizeBuffer: ImageBuffer<Float>,
                        normalizationFunction: @escaping (_ sourceData: UnsafeMutablePointer<UInt8>,
                                                          _ myImageData: BufferData<Float>,
                                                          _ rgbaIndex: Int) -> Void){
        let width: Int = normalizeBuffer.width()
        let height: Int = normalizeBuffer.height()
        
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
        
        let channels = normalizeBuffer.channels()
        let imageData: BufferData<Float> = normalizeBuffer.data()
        let dispatchGroup: DispatchGroup = DispatchGroup()
        
        for index in 0..<(regions.count){
            dispatchGroup.enter()
            DispatchQueue.global(qos: .background).async{
                let region: ImageRegion = regions[index]
                for row in region.top..<region.bottom{
                    for col in region.left..<region.right{
                        let rgbIndex = (row * width + col) * channels
                        normalizationFunction(bufferToNormalize,
                                              imageData,
                                              rgbIndex)
                        
                    }
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .global()){
            print("Finishing Image normalization process")
        }
        print("Starting image normalization")
        dispatchGroup.wait()
    }
    
    func doSomething(imageData: BufferData<Float>, rgbIndex: Int){
        imageData[rgbIndex] = 0.5
        imageData[rgbIndex + 1] = 0.75
        imageData[rgbIndex + 2] = 0.5
        imageData[rgbIndex + 3] = 1.0
    }
    
    func normalize(bufferToNormalize: UnsafeMutablePointer<UInt8>,
                   normalizeBufferData: BufferData<Float>,
                   rgbaIndex: Int){
        normalizeBufferData[rgbaIndex] = Float(bufferToNormalize[rgbaIndex]) / 255.0
        normalizeBufferData[rgbaIndex + 1] = Float(bufferToNormalize[rgbaIndex + 1]) / 255.0
        normalizeBufferData[rgbaIndex + 2] = Float(bufferToNormalize[rgbaIndex + 2]) / 255.0
        normalizeBufferData[rgbaIndex + 3] = Float(bufferToNormalize[rgbaIndex + 3]) / 255.0
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
