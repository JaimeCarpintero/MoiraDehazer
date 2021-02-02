//
//  IDehazeAlgorithm.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo on 2/1/21.
//  jaime.carpintero@uabc.edu.mx

import Foundation

protocol IDehazeAlgorithm{
    func apply(configuration: AbstractDehazeConfiguration,
               input: ImageBuffer<Float>,
               output: ImageBuffer<Float>)
}
