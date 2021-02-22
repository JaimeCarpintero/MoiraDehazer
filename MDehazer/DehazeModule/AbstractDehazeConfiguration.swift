//
//  AbstractDehazeConfiguration.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo on 2/1/21.
//  jaime.carpintero.carrillo@gmail.com

import Foundation

/*
 @AbstractDehazeConfiguration defines necessary data to be implemented by a dehazer configuration
 */
protocol AbstractDehazeConfiguration{
    var width: Int { get set }
    var height: Int { get set }
    var isAlphaRequired: Bool { get set }
}
