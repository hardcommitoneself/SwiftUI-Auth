//
//  ServiceProtocol.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import Combine

public protocol ServiceProtocol {
    func get<API: TargetType>(_ api: API) -> AnyPublisher<AnyObject?, Error>
    func getData<API: TargetType>(_ api: API) -> AnyPublisher<AnyObject?, Error>
    func getDictionary<API: TargetType>(_ api: API) -> AnyPublisher<[String: Any]?, Error>
    func getItem<API: TargetType, T: Codable>(_ api: API, type: T.Type) -> AnyPublisher<T?, Error>
    func getItems<API: TargetType, T: Codable>(_ api: API, type: T.Type) -> AnyPublisher<[T], Error>
}
