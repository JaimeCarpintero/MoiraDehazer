/*
 * IDehazeAlgorithm.swift
 * MDehazer
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

import Foundation

/*
 @IDehazeAlgorithm defines the necessary behavior to define a dehaze algorithm
 */
protocol IDehazeAlgorithm{
    func apply(configuration: AbstractDehazeConfiguration,
               input: ImageBuffer<Float>,
               output: ImageBuffer<Float>)
}
