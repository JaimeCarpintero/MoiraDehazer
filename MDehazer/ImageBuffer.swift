//
//  ImageBuffer.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021
//  jaime.carpintero@uabc.edu.mx

import Foundation

class ImageBuffer<T>{
    init(width: Int, height: Int, channels: Int, initialValue: T) {
        mWidth = width
        mHeight = height
        mImageSize = width * height * channels
        mChannels = channels
        mData = ImageBufferData<T>(dataSize: mImageSize, initVal: initialValue)
    }
    
    func setData(index: Int, value: T){
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
    
    func data() -> ImageBufferData<T>{
        return mData
    }

    
    private var mWidth: Int
    private var mHeight: Int
    private var mImageSize: Int
    private var mChannels: Int
    private var mData: ImageBufferData<T>
}
