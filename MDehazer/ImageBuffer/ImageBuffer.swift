//
//  ImageBuffer.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021
//  jaime.carpintero.carrillo@gmail.com

import Foundation

/*
 @ImageBuffer a template class that wraps essential image information
 */
class ImageBuffer<T>{
    
    /*
     @init constructor of @ref ImageBuffer class
     @param width a @ref Int that defines the width of the image
     @param height a @ref Int that defines the height of the image
     @param channels a @ref Int that defines the number of channels that the image is based on
     @param initialValue initial value that the image's buffer data will hold at the begining
     */
    init(width: Int, height: Int, channels: Int, initialValue: T) {
        mWidth = width
        mHeight = height
        mImageSize = width * height * channels
        mChannels = channels
        mData = BufferData<T>(dataSize: mImageSize, initVal: initialValue)
    }
    
    /*
     @setData a setter to image's buffer data in a particular index
     */
    func setData(index: Int, value: T){
        assert(index >= 0 && index < mImageSize)
        mData[index] = value
    }
    
    /*
     @width getter to retrieve image's width
     */
    func width() -> Int{
        return mWidth
    }
    
    /*
     @height getter to retrieve image's height
     */
    func height() -> Int{
        return mHeight
    }
    
    /*
     @size getter to retrieve image's size (width * height)
     */
    func size() -> Int{
        return mImageSize
    }
    
    /*
     @channels retrieves the image's number of channels
     */
    func channels() -> Int{
        return mChannels
    }
    
    /*
     @data retrieves the image's buffer data
     */
    func data() -> BufferData<T>{
        return mData
    }

    
    private var mWidth: Int
    private var mHeight: Int
    private var mImageSize: Int
    private var mChannels: Int
    private var mData: BufferData<T>
}
