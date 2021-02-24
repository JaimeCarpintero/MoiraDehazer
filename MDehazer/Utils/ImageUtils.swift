/*
 * ImageUitls.swift
 * MDehazer
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

import Foundation

let channelRGB: Int = 3
let channelRGBA: Int = 4

/*
 @ImageDispatcher  performs multithreaded process related to normalization/dehazing process
 */
class ImageDispatcher
{
    /*
     @dispatchtDehazeFunction executes the process to dehaze the input image in a multithreaded fashion
     @param imageBuffer a @ref mageBuffer<Float> that holds the haze image's data
     @param outputBuffer a @ref mageBuffer<Float> that will hold the dehaze image's data
     @param transmissionMap a @ref BufferData<Float> that holds the data of the transmission map
     @param ambientLightR a @ref Float that defines the red component ambient light
     @param ambientLightG a @ref Float that defines the green component ambient light
     @param ambientLightB a @ref Float that defines the blue component ambient light
     @param samplerFunction a function that will be executed in a multithread fashion
     */
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
    
    /*
     @dispatchTransmissionMapFunction executes the process to generate the transmission map in a multithreaded fashion
     @param imageBuffer a @ref mageBuffer<Float> that holds the image's data
     @param transmissionMap a @ref BufferData<Float> that holds the data of the transmission map
     @param windowSize a @ref Int that defines the window size of the sampler function
     @param ambientLightR a @ref Float that defines the red component ambient light
     @param ambientLightG a @ref Float that defines the green component ambient light
     @param ambientLightB a @ref Float that defines the blue component ambient light
     @param wHazeFator a @ref Float that defines the haze factor that should be used in the tranmission map generation process
     @param samplerFunction a function that will be executed in a multithread fashion
     */
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
    
    /*
     @normalizeImage normalizes 8bithdepth image data
     @param bufferToNormalize an @ref UnsafeMutablePointer<Uint8> that holds the image to be normalized
     @param normalizeBuffer a @ref ImageBuffer<Float> that will hold the normalized data
     @param normalizationFunction a function that will be performed in a multithreaded way to normalize the input data provided
     */
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
    
    /*
     @normalize sampler function used by @ref normalizeImage to normalize image data
     */
    func normalize(bufferToNormalize: UnsafeMutablePointer<UInt8>,
                   normalizeBufferData: BufferData<Float>,
                   rgbaIndex: Int){
        normalizeBufferData[rgbaIndex] = Float(bufferToNormalize[rgbaIndex]) / 255.0
        normalizeBufferData[rgbaIndex + 1] = Float(bufferToNormalize[rgbaIndex + 1]) / 255.0
        normalizeBufferData[rgbaIndex + 2] = Float(bufferToNormalize[rgbaIndex + 2]) / 255.0
        normalizeBufferData[rgbaIndex + 3] = Float(bufferToNormalize[rgbaIndex + 3]) / 255.0
    }

    /*
     @ImageRegion helps to define regions for to divide image in order to perform process in a multithread fashion
     */
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
