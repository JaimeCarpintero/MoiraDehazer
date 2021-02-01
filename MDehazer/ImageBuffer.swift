//
//  ImageBuffer.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021

import Foundation

class ImageBuffer{
    init(width: Int, height: Int, channels: Int) {
        mWidth = width
        mHeight = height
        mImageSize = width * height * channels
        mChannels = channels
        mData = ImageBufferData<UInt8>(dataSize: mImageSize, initVal: 0)
    }
    
    func setData(index: Int, value: UInt8){
        assert(index >= 0 && index < mImageSize)
        mData[index] = value
    }
    
    func width() -> Int{
        return mWidth
    }
    
    func height() -> Int{
        return mHeight
    }
    
    func size() -> Int{
        return mImageSize
    }
    
    func channels() -> Int{
        return mChannels
    }
    
    func data() -> ImageBufferData<UInt8>{
        return mData
    }
    
    
    private var mWidth: Int
    private var mHeight: Int
    private var mImageSize: Int
    private var mChannels: Int
    private var mData: ImageBufferData<UInt8>
}
