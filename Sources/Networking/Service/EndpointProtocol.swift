//
//  File.swift
//  
//
//  Created by Burak AKIN on 6.09.2021.
//

import Foundation

public protocol EndpointProtocol {
    var baseURL: URL { get }
    var path: String? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
