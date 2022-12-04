//
//  BaseTargetType.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import UIKit
import Alamofire

protocol ExampleTargetType: TargetType {
    
}

extension ExampleTargetType {
    var baseURL: String {
        return "https://api.appcenter.ms/v0.1/apps/"
    }
    
    var headers: HTTPHeaders {
        return .default
    }
}

extension HTTPHeaders {
    public static let `default`: HTTPHeaders = [.defaultAcceptEncoding,
                                                .defaultAcceptLanguage,
                                                .defaultUserAgent]
    
    public static let authencation: HTTPHeaders = ["X-API-Token": "a295cf27e47f9942ae15ad5535894df25adde254",
                                                  "Content-Type": "application/json"
    ]
}

