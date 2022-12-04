//
//  BaseService.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import Alamofire
import Combine

class BaseService: ServiceProtocol {
    let timeOut: TimeInterval
    /// Properties
    let apiQueue = DispatchQueue(label: "API", qos: .background)
    
    public init(timeOut: TimeInterval = 60) {
        self.timeOut = timeOut
    }
    
    func get<API>(_ api: API) -> AnyPublisher<AnyObject?, Error> where API : TargetType {
        let request = BaseRequest(api: api).getRequest()
        return Future<AnyObject?, Error> { handler in
            if !NetworkReachabilityManager()!.isReachable {
                handler(.failure(ServiceError.NetworkError))
                return
            }
            
            request.responseJSON(queue: self.apiQueue, completionHandler: { (response) in
                guard let statusCode = response.response?.statusCode else {
                    handler(.failure(ServiceError.Unknown))
                    return
                }
                
                if statusCode != 200 && statusCode != 201 {
                    if let failure = response.error {
                        handler(.failure(failure))
                    }
                    if let data = response.value as AnyObject? {
                        handler(.failure(ServiceError.Error(data: data, api: api)))
                        return
                    }
                    handler(.failure(ServiceError.Error(data: nil, api: api)))
                    return
                }
                
                handler(.success(response.value as? AnyObject))
            })
        }.eraseToAnyPublisher()
    }
    
    func getData<API>(_ api: API) -> AnyPublisher<AnyObject?, Error> where API : TargetType {
        let request = BaseRequest(api: api).getRequest()
        return Future<AnyObject?, Error> { handler in
            request.responseData(queue: self.apiQueue, completionHandler: { (response) in
                guard let statusCode = response.response?.statusCode else {
                    handler(.failure(ServiceError.Unknown))
                    return
                }
                
                if statusCode != 200 {
                    if let failure = response.error {
                        handler(.failure(failure))
                    }
                    if let data = response.value as AnyObject? {
                        handler(.failure(ServiceError.Error(data: data, api: api)))
                        return
                    }
                    handler(.failure(ServiceError.Error(data: nil, api: api)))
                    return
                }
                
                handler(.success(response.value as? AnyObject))
            })
        }.eraseToAnyPublisher()
    }
    
    func getDictionary<API>(_ api: API) -> AnyPublisher<[String : Any]?, Error> where API : TargetType {
        return self.get(api).flatMap { response -> AnyPublisher<[String : Any]?, Error> in
            let data = response as? [String: Any]
            return Result<[String : Any]?, Error>.Publisher(.success(data)).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func getItem<API, T>(_ api: API, type: T.Type) -> AnyPublisher<T?, Error> where API : TargetType, T : Codable {
        return self.getDictionary(api).flatMap { (dictionary) -> AnyPublisher<T?, Error> in
            do {
                if let responseJSON = dictionary {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: responseJSON, options: []) {
                        let data  = try JSONDecoder().decode(type, from: jsonData )
                        return Result<T?, Error>.Publisher(.success(data)).eraseToAnyPublisher()
                    }
                }
            } catch {
                print(error)
            }
            
            return Result<T?, Error>.Publisher(.failure(ServiceError.ParseDataError)).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func getItems<API, T>(_ api: API, type: T.Type) -> AnyPublisher<[T], Error> where API : TargetType, T : Decodable, T : Encodable {
        return self.get(api).flatMap { (serviceResponse) -> AnyPublisher<[T], Error> in
            if let responseJSON = serviceResponse as? [[String: Any]] {
                if let jsonData = try? JSONSerialization.data(withJSONObject: responseJSON, options: []),
                   let data : [T]  = try? JSONDecoder().decode([T].self, from: jsonData ) {
                    return Result<[T], Error>.Publisher(.success(data)).eraseToAnyPublisher()
                }
                
                return Result<[T], Error>.Publisher(.failure(ServiceError.ParseDataError)).eraseToAnyPublisher()
            }
            
            return Result<[T], Error>.Publisher(.failure(ServiceError.ParseDataError)).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
