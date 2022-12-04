//
//  TargetType.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import UIKit
import Alamofire

public protocol TargetType {
    /// The target's base `URL`.
    var baseURL: String { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Alamofire.HTTPMethod { get }

    var encoding: ParameterEncoding {get}

    var params: [String: Any]? {get}

    /// The headers to be used in the request.
    var headers: HTTPHeaders { get }

    var isUpload: Bool {get}

    var isDownload: Bool { get }

    var fileDownload: String { get }

    var link: String {get}
    
    var fileName: String? {get}
}

public extension TargetType {
    var link: String {
        return "\(self.baseURL)\(self.path)"
    }

    var isUpload: Bool {
        return false
    }

    var isDownload: Bool {
        return false
    }

    var fileDownload: String {
        return ""
    }
    
    var fileName: String? {
        return nil
    }
    
    var label: String {
        let mirror = Mirror(reflecting: self)
        return mirror.children.first?.label ?? String(describing: self)
    }
    
}

enum Encoder {
    case JSONParameterEncoder
    case URLEncodedFormParameterEncoder
}
