//
//  Authencation+API.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import UIKit
import Alamofire

enum AuthencationTargetType {
    case signIn(username: String, password: String)
}

extension AuthencationTargetType: ExampleTargetType {
    var path: String {
        return "MCredit/MCredit-Android/uploads/releases"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var headers: HTTPHeaders {
        return .authencation
    }
    
    var params: [String : Any]? {
        switch self {
        case .signIn(let username, let password):
            return ["username": username, "password": password]
        }
    }
}
