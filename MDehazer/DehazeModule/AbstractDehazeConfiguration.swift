//
//  AbstractDehazeConfiguration.swift
//  MDehazer
//
//  Created by Jaime Carpintero Carrillo on 2/1/21.
//  jaime.carpintero@uabc.edu.mx

import Foundation

protocol AbstractDehazeConfiguration{
    var width: Int { get set }
    var height: Int { get set }
    var isAlphaRequired: Bool { get set }
}
