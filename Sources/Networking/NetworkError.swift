//
//  File.swift
//  
//
//  Created by Burak AKIN on 5.09.2021.
//

import Foundation


public enum NetworkError: Error {
    case parametersNil
    case noData
    case statusCode(Int)
    case decodingFailed(Error)
    case encodingFailed(Error)
    case underlying(Error)
    
}


extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .parametersNil:
            return "Parameter nil."
        case .noData:
            return "No data found."
        case .statusCode(let code):
            return "Status code \(code)."
        case .decodingFailed(let error):
            return "Decoding failed \(error.localizedDescription)."
        case .encodingFailed(let error):
            return "Encoding failed \(error.localizedDescription). "
        case .underlying(let error):
            return "\(error.localizedDescription)"
        
        }
    }
}



