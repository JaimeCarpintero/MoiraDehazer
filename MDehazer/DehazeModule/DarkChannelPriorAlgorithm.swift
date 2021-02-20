//
//  DarkChannelPriorAlgorithm.swift
//  MDehazer
//
//  Created by Jaime_Viri on 2/1/21.
//

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
            let inputImageData: ImageBufferData<Float> = input.data()
            estimateAmbientLight(inputData: inputImageData,
                                 channels: channels,
                                 width: width,
                                 height: height,
                                 windowSize: windowSize)
            
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
    
    private func estimateAmbientLight(inputData: ImageBufferData<Float>,
                                      channels: Int,
                                      width: Int,
                                      height: Int,
                                      windowSize: Int)
    {
        let windowHalf: Int = windowSize / 2
        let imageSize: Int = width * height
        
        var minIntensityR = DarkChannelPriorAlgorithm.mMaxBrightness
        var minIntensityG = DarkChannelPriorAlgorithm.mMaxBrightness
        var minIntensityB = DarkChannelPriorAlgorithm.mMaxBrightness
        
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
        }
        let minIntensityRGB: Float = min(min(minIntensityR, minIntensityG), minIntensityB)
        //push minIntensity into insertion sort queue
    }
    
    private var mTransmissionMap: ImageBuffer<Float>
    private var mAmbientLight: AmbientLight
    private var mCurrentWidth: Int
    private var mCurrentHeight: Int
    private static let mMaxBrightness: Float = 65535.0
}
