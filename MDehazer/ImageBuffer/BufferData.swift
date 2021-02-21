//
//  ImageBufferData.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo 23-Jan-2021
//  jaime.carpintero.carrillo@gmail.com

import Foundation

class BufferData<T>{
    init(dataSize: Int, initVal: T) {
        mData = UnsafeMutablePointer<T>.allocate(capacity: dataSize)
        for index in 0..<dataSize{
            mData[index] = initVal
        }
    }
    init(dataSize: Int) {
        mData = UnsafeMutablePointer<T>.allocate(capacity: dataSize)
    }
    subscript(index: Int) -> T{
        get{
            return mData[index]
        }
        set(newElement){
            mData[index] = newElement
        }
    }
    
    private var mData: UnsafeMutablePointer<T>
}
