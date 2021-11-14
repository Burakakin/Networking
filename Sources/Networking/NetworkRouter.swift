//
//  File.swift
//  
//
//  Created by Burak AKIN on 5.09.2021.
//

import Foundation

//MARK: EXAMPLE USAGE

//private let router1 = Router<EarthquakeEndpoint>()

//        router1.request(.getEarthquakeList) { (result: Result<[EarthquakeInfo], Error>) in
//            switch result {
//            case .success(let earthquakes):
//                print(earthquakes[0].geometry.coordinates)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }

public typealias NetworkRouterCompletion<T: Codable> = (Result<T, Error>) -> ()

public protocol NetworkRouter: class {
    associatedtype Endpoint: EndpointProtocol
    func request<T: Codable>(_ route: Endpoint, completion: @escaping NetworkRouterCompletion<T>)
    func cancel()
}



public class Router<Endpoint: EndpointProtocol>: NetworkRouter {
   
    private var task: URLSessionTask?
    private var session: URLSession
    
    public init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }
    
    public func request<T: Codable>(_ route: Endpoint, completion: @escaping NetworkRouterCompletion<T>) {
        
        do {
            let request = try buildRequest(from: route)
            let task = session.dataTask(with: request) { data, urlResponse, error in
                
                let response = Response(urlRequest: request, data: data, httpURLResponse: urlResponse as? HTTPURLResponse)
                // DEBUG Description.
                // Disable in PROD Mode.
                #if DEBUG
                print(response.debugDescription)
                #endif
                
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpURLResponse = response.httpURLResponse, 200..<300 ~= httpURLResponse.statusCode else {
                    completion(.failure(NetworkError.statusCode(response.httpURLResponse?.statusCode ?? 0)))
                    return
                }

                do {
                    let decodedData = try response.map(to: T.self)
                    completion(.success(decodedData))
                }
                catch {
                    completion(.failure(error))
                }
                
                
            }
            task.resume()
        }
        catch let error {
            completion(.failure(NetworkError.underlying(error)))
        }
        
        
    }
    
    
    public func cancel() {
        self.task?.cancel()
    }
    
    
    
    
}

extension Router {
    func buildRequest(from route: EndpointProtocol) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path ?? ""),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestwithParameters(let bodyParameters,
                                        let urlParameters):
                
                try configureParameters(bodyParameters: bodyParameters,
                                        urlParameters: urlParameters,
                                        request: &request)
                
            case .requestwithParametersAndHeaders(let bodyParameters,
                                                  let urlParameters,
                                                  let additionalHeaders):
                try configureParameters(bodyParameters: bodyParameters,
                                        urlParameters: urlParameters,
                                        request: &request)
                addAdditionalHeaders(additionalHeaders,
                                     request: &request)
                
            }
            return request
        }
        catch {
            throw error
        }
    }
    
    
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, parameters: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, parameters: urlParameters)
            }
            
        }
        catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

