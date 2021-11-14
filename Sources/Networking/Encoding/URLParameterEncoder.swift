//
//  File.swift
//  
//
//  Created by Burak AKIN on 6.09.2021.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.parametersNil }
        if var urlComponenets = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponenets.queryItems = nil
            
            for (key, value) in parameters {
                urlComponenets.queryItems?.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            urlRequest.url = urlComponenets.url
            
        }
    }
    
    
}
