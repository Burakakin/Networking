//
//  File.swift
//  
//
//  Created by Burak AKIN on 6.09.2021.
//

import Foundation

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws
}
