/*
 * AbstractDehazeConfiguration.swift
 * MDehazer
 * (c) 2021 Jaime Carpintero Carrillo
 * jaime.carpintero.carrillo@gmail.com
 * jaime.carpintero@uabc.edu.mx
 * This code is licensed under MIT license (see LICENSE.txt for details)
*/

import Foundation

/*
 @AbstractDehazeConfiguration defines necessary data to be implemented by a dehazer configuration
 */
protocol AbstractDehazeConfiguration{
    var width: Int { get set }
    var height: Int { get set }
    var isAlphaRequired: Bool { get set }
}
