/*
 * ImageBufferData.swift
 * MDehazer
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

import Foundation

/*
 @BufferData<T> template class that encapsulates a data that can be accessed in array form
 */
class BufferData<T>{
    /*
     @init constructor of BufferData class that supports the initialization of the buffer with an initial value
     @param dataSize a @ref Int that defines the buffer's data size
     @param initVal a T value that will be placed throughout the buffer's data
     */
    init(dataSize: Int, initVal: T) {
        mData = UnsafeMutablePointer<T>.allocate(capacity: dataSize)
        for index in 0..<dataSize{
            mData[index] = initVal
        }
    }
    
    /*
     @init constructor of BufferData class
     @param dataSize a @ref Int that defines the buffer's data size
     */
    init(dataSize: Int) {
        mData = UnsafeMutablePointer<T>.allocate(capacity: dataSize)
    }
    
    //subscript that allows the usage of the [] operator 
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
