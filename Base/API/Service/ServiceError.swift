//
//  ServiceError.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import UIKit

enum ServiceError: Error {
    case Unknown
    case ParseDataError
    case NetworkError
    case Error(data: AnyObject?, api: TargetType)
}
