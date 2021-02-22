//
//  IDehazeAlgorithm.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo on 2/1/21.
//  jaime.carpintero.carrillo@gmail.com

import Foundation

/*
 @IDehazeAlgorithm defines the necessary behavior to define a dehaze algorithm
 */
protocol IDehazeAlgorithm{
    func apply(configuration: AbstractDehazeConfiguration,
               input: ImageBuffer<Float>,
               output: ImageBuffer<Float>)
}
