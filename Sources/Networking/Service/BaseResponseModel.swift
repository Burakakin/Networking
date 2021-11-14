//
//  File.swift
//  
//
//  Created by Burak AKIN on 6.09.2021.
//

import Foundation

struct Base<T: Codable>: Codable {
    var result: T
    var success: Bool
}
