/*
 * DarkChannelPriorAlgorithm.swift
 * MDehazer
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

import Foundation

class DarkChannelPriorAlgorithm : IDehazeAlgorithm{
    
    init(){
        mAmbientLight = AmbientLight()
        mCurrentWidth = 1
        mCurrentHeight = 1
        mTransmissionMap = ImageBuffer<Float>(width: mCurrentWidth,
                                              height: mCurrentHeight,
                                              channels: 1,
                                              initialValue: 1.0)
    }
    
    func apply(configuration: AbstractDehazeConfiguration,
               input: ImageBuffer<Float>,
               output: ImageBuffer<Float>){
    
        if let config = configuration as? DarkChannelPriorConfiguration{
            let width: Int = config.width
            let height: Int = config.height
            let channels: Int = (config.isAlphaRequired) ? 4 : 3
            assert(width > 0)
            assert(height > 0)
            
            if(mCurrentWidth != width || mCurrentHeight != height){
                mTransmissionMap = ImageBuffer<Float>(width: width,
                                                      height: height,
                                                      channels: 1,
                                                      initialValue: 0.0)
                mCurrentWidth = width
                mCurrentHeight = height
            }
            
            let windowSize: Int = config.windowSize
            let hazeFactor: Float = config.hazeFactor
            let inputImageData: BufferData<Float> = input.data()
            let transmissionMapData: BufferData<Float> = mTransmissionMap.data()
            
            estimateAmbientLight(inputData: inputImageData,
                                 channels: channels,
                                 width: width,
                                 height: height,
                                 windowSize: windowSize)
            
            estimateTransmission(input: input,
                                 transmissionMap: mTransmissionMap,
                                 windowSize: windowSize,
                                 ambientLight: mAmbientLight,
                                 wHazeFactor: hazeFactor)

            print("Starting softMatting process")
            let softMattingWindowSize: Int = 7
            let softMattingWrapper: SoftMattingWrapper = SoftMattingWrapper()
            softMattingWrapper.softMatting(inputImageData.rawData(),
                                           tMap: transmissionMapData.rawData(),
                                           channels: channels,
                                           width: width,
                                           height: height,
                                           softMattingWindowSize: softMattingWindowSize)
    
            print("Finishing Soft matting process")
            
            dehaze(input: input,
                   output: output,
                   transmissionMap: mTransmissionMap,
                   ambientLight: mAmbientLight)
        }
    }
    
    private struct AmbientLight{
        init(){
            r = 0
            g = 0
            b = 0
        }
        var r: Float
        var g: Float
        var b: Float
    }
    
    private func estimateAmbientLight(inputData: BufferData<Float>,
                                      channels: Int,
                                      width: Int,
                                      height: Int,
                                      windowSize: Int)
    {
        print("estimating ambient light")
        let windowHalf: Int = windowSize / 2
        let imageSize: Int = width * height
        
        var minIntensityR = DarkChannelPriorAlgorithm.mMaxBrightness
        var minIntensityG = DarkChannelPriorAlgorithm.mMaxBrightness
        var minIntensityB = DarkChannelPriorAlgorithm.mMaxBrightness
        let brightestDarkPixels = AmbientLightBrightestPixels(size: imageSize)
        
        for index in 0..<imageSize{
            minIntensityR = DarkChannelPriorAlgorithm.mMaxBrightness
            minIntensityG = DarkChannelPriorAlgorithm.mMaxBrightness
            minIntensityB = DarkChannelPriorAlgorithm.mMaxBrightness
            
            let currentRow: Int = index / width
            let currentCol: Int = index % width
            
            for windowRow in -windowHalf...windowHalf{
                for windowCol in -windowHalf...windowHalf{
                    let rowOnImage: Int = (currentRow + windowRow)
                    let colOnImage: Int = (currentCol + windowCol)
                    if((rowOnImage >= 0 && rowOnImage < height)
                        && (colOnImage >= 0 && colOnImage < width)){
                        
                        let rgbaIndex: Int = ((rowOnImage * width) + colOnImage) * channels
                        let rValue: Float = inputData[rgbaIndex]
                        let gValue: Float = inputData[rgbaIndex + 1]
                        let bValue: Float = inputData[rgbaIndex + 2]
                        //alpha is ignored
                        if(rValue < minIntensityR){
                            minIntensityR = rValue
                        }
                        
                        if(gValue < minIntensityG){
                            minIntensityG = gValue
                        }
                        
                        if(bValue < minIntensityB){
                            minIntensityB = bValue
                        }
                    }
                }
            }
            let minIntensityAtPixel: Float = min(min(minIntensityR, minIntensityG), minIntensityB)
            //push minIntensity into insertion sort queue
            brightestDarkPixels.insert(newDarkPixel: AmbientLightDarkPixel(index: index,
                                                                           row: currentRow,
                                                                           col: currentCol,
                                                                           value: minIntensityAtPixel))
        }
        
        /* NOTE: [Jaime] among dark pixels with min intensity,
         * map their location in the original image and get the maximim
         */
        print("Mapping min intensity dark pixels into original image")
        let darkPixelsSize: Int = brightestDarkPixels.getBrightestPixelsSize()
        let darkPixelsData = brightestDarkPixels.getBrightestPixels()
        for index in 0..<darkPixelsSize{
            let minDarkPixelIndex = (darkPixelsData[index].location.index) * channels
            let r = inputData[minDarkPixelIndex]
            let g = inputData[minDarkPixelIndex + 1]
            let b = inputData[minDarkPixelIndex + 2]
            //Alpha is ignored
            if(r > mAmbientLight.r){
                mAmbientLight.r = r
            }
            
            if(g > mAmbientLight.g){
                mAmbientLight.g = g
            }
            
            if(b > mAmbientLight.b){
                mAmbientLight.b = b
            }
        }
        print("Finishing estimating ambient light")
    }
    
    private func estimateTransmission(input: ImageBuffer<Float>,
                                      transmissionMap: ImageBuffer<Float>,
                                      windowSize: Int,
                                      ambientLight: AmbientLight,
                                      wHazeFactor: Float){
        let imageDispatcher: ImageDispatcher = ImageDispatcher()
        
        imageDispatcher.dispatchTransmissionMapFunction(imageBuffer: input,
                                                        transmissionMap: transmissionMap.data(),
                                                        windowSize: windowSize,
                                                        ambientLightR: ambientLight.r,
                                                        ambientLightG: ambientLight.g,
                                                        ambientLightB: ambientLight.b,
                                                        wHazeFactor: wHazeFactor,
                                                        samplerFunction: sampleTransmission)
        
    }
    
    private func sampleTransmission(input: BufferData<Float>,
                                    transmissionMap: BufferData<Float>,
                                    index: Int,
                                    width: Int,
                                    height: Int,
                                    channels: Int,
                                    windowSize: Int,
                                    ambientLightR: Float,
                                    ambientLightG: Float,
                                    ambientLightB: Float,
                                    wHazeFactor: Float){
        
        let currentRow: Int = index / width
        let currentCol: Int = index % width
        let windowHalf: Int = windowSize / 2
        
        var minTransmissionR: Float = DarkChannelPriorAlgorithm.mMaxBrightness
        var minTransmissionG: Float = DarkChannelPriorAlgorithm.mMaxBrightness
        var minTransmissionB: Float = DarkChannelPriorAlgorithm.mMaxBrightness
        
        for windowRow in -windowHalf...windowHalf{
            for windowCol in -windowHalf...windowHalf{
                let rowOnImage: Int = (currentRow + windowRow)
                let colOnImage: Int = (currentCol + windowCol)
                if((rowOnImage >= 0 && rowOnImage < height)
                    && (colOnImage >= 0 && colOnImage < width)){
                    
                    let rgbaIndex: Int = ((rowOnImage * width) + colOnImage) * channels
                    let r: Float = input[rgbaIndex]
                    let g: Float = input[rgbaIndex + 1]
                    let b: Float = input[rgbaIndex + 2]
                    //alpha is ignored
                    if(r < minTransmissionR){
                        minTransmissionR = r
                    }
                    
                    if(g < minTransmissionG){
                        minTransmissionG = g
                    }
                    
                    if(b < minTransmissionB){
                        minTransmissionB = b
                    }
                }
            }
        }
        
        let minTransmissionRWithAmbient: Float = minTransmissionR / ambientLightR
        let minTransmissionGWithAmbient: Float = minTransmissionG / ambientLightG
        let minTransmissionBWithAmbient: Float = minTransmissionB / ambientLightB
        let minTransmissionRGB = min(min(minTransmissionRWithAmbient,
                                         minTransmissionGWithAmbient), minTransmissionBWithAmbient)
        let transmissionToStore: Float = 1.0 - (wHazeFactor * minTransmissionRGB)
        transmissionMap[index] = transmissionToStore
    }
    
    private func dehaze(input: ImageBuffer<Float>,
                        output: ImageBuffer<Float>,
                        transmissionMap: ImageBuffer<Float>,
                        ambientLight: AmbientLight){
        let imageDispatcher: ImageDispatcher = ImageDispatcher()
        imageDispatcher.dispatchtDehazeFunction(imageBuffer: input,
                                                outputBuffer: output,
                                                transmissionMap: transmissionMap.data(),
                                                ambientLightR: ambientLight.r,
                                                ambientLightG: ambientLight.g,
                                                ambientLightB: ambientLight.b,
                                                samplerFunction: dehazeSampler)
    }
    
    private func dehazeSampler(input: BufferData<Float>,
                               output: BufferData<Float>,
                               transmissionMap: BufferData<Float>,
                               index: Int,
                               channels: Int,
                               ambientLightR: Float,
                               ambientLightG: Float,
                               ambientLightB: Float){
        
        let minTransmission: Float = DarkChannelPriorAlgorithm.mMinTransmission
        let rgbaIndex = index * channels
        let r: Float = input[rgbaIndex]
        let g: Float = input[rgbaIndex + 1]
        let b: Float = input[rgbaIndex + 2]
        //alpha is ignored
        
        let inputRWithoutAmbientLight: Float = r - ambientLightR
        let inputGWithoutAmbientLight: Float = g - ambientLightG
        let inputBWithoutAmbientLight: Float = b - ambientLightB
        
        let transmissionForPixel: Float = max(transmissionMap[index], minTransmission)
        
        let outputR: Float = max(min((inputRWithoutAmbientLight / transmissionForPixel) + ambientLightR, 1.0), 0.0)
        let outputG: Float = max(min((inputGWithoutAmbientLight / transmissionForPixel) + ambientLightG, 1.0), 0.0)
        let outputB: Float = max(min((inputBWithoutAmbientLight / transmissionForPixel) + ambientLightB, 1.0), 0.0)
        
        output[rgbaIndex] = outputR
        output[rgbaIndex + 1] = outputG
        output[rgbaIndex + 2] = outputB
        //alpha ignored
    }
    
    private var mTransmissionMap: ImageBuffer<Float>
    private var mAmbientLight: AmbientLight
    private var mCurrentWidth: Int
    private var mCurrentHeight: Int
    private static let mMaxBrightness: Float = 65535.0
    private static let mMinTransmission: Float = 0.1
}
