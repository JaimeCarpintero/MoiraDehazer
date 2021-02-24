/*
 * AmbientLightDarkPixel.swift
 * MDehazer
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

import Foundation

struct PixelLocation{
    
    init(index: Int, row: Int, col: Int){
        self.index = index
        self.row = row
        self.col = col
    }
    
    let index: Int
    let row: Int
    let col: Int
}

struct AmbientLightDarkPixel
{
    init(index: Int, row: Int, col: Int, value: Float){
        self.location = PixelLocation(index: index, row: row, col: col)
        self.value = value
    }
    
    let location: PixelLocation
    let value: Float
}
