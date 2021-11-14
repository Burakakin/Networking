//
//  File.swift
//  
//
//  Created by Burak AKIN on 6.09.2021.
//

import Foundation


public typealias HTTPHeaders = [String:String]

public typealias Parameters = [String: Any]

public enum HTTPTask {
    
    case request
    case requestwithParameters(bodyParameters: Parameters?,
                               urlParameters: Parameters?)
    case requestwithParametersAndHeaders(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         additionalHeaders: HTTPHeaders?)
}
