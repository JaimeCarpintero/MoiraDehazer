//
//  AmbientLightBrightestPixels.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo on 2/21/21.
//  jaime.carpintero.carrillo@gmail.com

import Foundation

class AmbientLightBrightestPixels
{
    init(size: Int){
        mSize = 0
        mCurrentMin = -1.0
        //NOTE: [Jaime] store .1% of brightest pixels amon dark pixels JDark(x)
        mMaxSize = Int(Float(size) * 0.001)
        mBrightestPixels = BufferData<AmbientLightDarkPixel>(dataSize: mMaxSize)
        assert(mMaxSize > 0)
    }
    
    func insert(newDarkPixel: AmbientLightDarkPixel){
        if(mCurrentMin > newDarkPixel.value){
            return
        }
        
        for index in 0..<mSize{
            if(newDarkPixel.value > mBrightestPixels[index].value){
                if(mSize < mMaxSize){
                    mSize += 1
                }
                for swapIndex in stride(from: mSize - 1, to: index + 1, by: -1){
                    mBrightestPixels[swapIndex] = mBrightestPixels[swapIndex - 1]
                }
                mBrightestPixels[index] = newDarkPixel
                mCurrentMin = mBrightestPixels[mSize - 1].value
                return
            }
        }
        
        if(mSize < mMaxSize){
            mBrightestPixels[mSize] = newDarkPixel
            mSize += 1
            mCurrentMin = mBrightestPixels[mSize - 1].value
        }
    }
    
    func getBrightestPixels() -> BufferData<AmbientLightDarkPixel>{
        return mBrightestPixels
    }
    
    func getBrightestPixelsSize() -> Int{
        return mSize
    }
    
    private var mSize: Int
    private let mMaxSize: Int
    private var mCurrentMin: Float
    private var mBrightestPixels: BufferData<AmbientLightDarkPixel>
}
