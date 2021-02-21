//
//  AmbientLightDarkPixel.swift
//  MDehazer
//
//  Created by Jaime Carpintero on 2/21/21.
//  jaime.carpintero.carrillo@gmail.com

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
