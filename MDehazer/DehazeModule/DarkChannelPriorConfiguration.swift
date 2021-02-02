//
//  DarkChannelPriorConfiguration.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo on 2/1/21.
//  jaime.carpintero@uabc.edu.mx

import Foundation

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
