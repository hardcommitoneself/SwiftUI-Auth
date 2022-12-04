//
//  LoginModel.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import Foundation

// MARK: - Welcome
struct LoginModel: Codable {
    let id, packageAssetID: String
    let uploadDomain: String
    let token, urlEncodedToken: String

    enum CodingKeys: String, CodingKey {
        case id
        case packageAssetID = "package_asset_id"
        case uploadDomain = "upload_domain"
        case token
        case urlEncodedToken = "url_encoded_token"
    }
}
