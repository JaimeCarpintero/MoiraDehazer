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
        
        var result: Bool = false
        if let config = configuration as? DarkChannelPriorConfiguration{
            let width: Int = config.width
            let height: Int = config.height
            let channels: Int = (config.isAlphaRequired) ? 4 : 3
            assert(width > 0)
            assert(height > 0)
            
            if(mCurrentWidth != width || mCurrentHeight != height){
                mTransmissionMap = ImageBuffer<Float>(width: width,
                                                      height: height,
                                                      channels: channels,
                                                      initialValue: 0.0)
                mCurrentWidth = width
                mCurrentHeight = height
            }
            
            let windowSize: Int = config.windowSize
            let hazeFactor: Float = config.hazeFactor
            
        }
    }
    
    private struct AmbientLight{
        init() {
            r = 0
            g = 0
            b = 0
        }
        var r: Float
        var g: Float
        var b: Float
    }
    
    private var mTransmissionMap: ImageBuffer<Float>
    private var mAmbientLight: AmbientLight
    private var mCurrentWidth: Int
    private var mCurrentHeight: Int
}
