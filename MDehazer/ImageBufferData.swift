//
//  ImageBufferData.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021

import Foundation

class ImageBufferData<T>{
    init(dataSize: Int, initVal: T) {
        mData = Array<T>(repeating: initVal, count: dataSize)
    }
    subscript(index: Int) -> T{
        get{
            return mData[index]
        }
        set(newElement){
            mData[index] = newElement
        }
    }
    
    private var mData: Array<T>
}