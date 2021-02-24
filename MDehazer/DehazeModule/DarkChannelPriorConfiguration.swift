/*
 * DarkChannelPriorConfiguration.swift
 * MDehazer
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

import Foundation

/*
 @DarkChannelPriorConfiguration wraps the essential data to perform a DarkChannelPrior based dehaze algorithm
 */
struct DarkChannelPriorConfiguration : AbstractDehazeConfiguration{
    init(width: Int,
         height: Int,
         isAlphaPresent: Bool,
         windowSize: Int,
         wHazeFactor: Float) {
        
        self.width = width
        self.height = height
        isAlphaRequired = isAlphaPresent
        mWindowSize = windowSize
        mHazeFactor = wHazeFactor
    }
    
    var windowSize: Int{
        get{
            return mWindowSize
        }
    }
    
    var hazeFactor: Float{
        get{
            return mHazeFactor
        }
    }
    
    var width: Int
    var height: Int
    var isAlphaRequired: Bool
    private var mWindowSize: Int
    private var mHazeFactor: Float
}
