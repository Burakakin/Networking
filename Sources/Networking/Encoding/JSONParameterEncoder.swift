//
//  File.swift
//  
//
//  Created by Burak AKIN on 6.09.2021.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
        }
        catch let error {
            throw NetworkError.encodingFailed(error)
        }
    }
    
    
}
