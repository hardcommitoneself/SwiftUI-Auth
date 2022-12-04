//
//  BaseRequest.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import UIKit
import Alamofire
import PDFKit
import UIKit
import MobileCoreServices
import AVFoundation

struct BaseRequest<API : TargetType> {
    let api: API
    let timeout: TimeInterval

    init(api: API, timeout:TimeInterval = 60) {
        self.api = api
        self.timeout = timeout
    }

    func getRequest() -> DataRequest {
        if api.isUpload {
            return AF.upload(multipartFormData: { (multipartFormData) in
                self.setMutipartFormData(multipartFormData: multipartFormData, params: api.params)
            },
            to: api.link,
            usingThreshold: UInt64.init(),
            method: api.method,
            headers: api.headers) { $0.timeoutInterval = timeout }
        }
        
        return AF.request(api.link,
                          method: api.method,
                          parameters: api.params,
                          encoding: api.encoding,
                          headers: api.headers) {
            $0.timeoutInterval = timeout
        }

    }
    
    fileprivate func setMutipartFormData(multipartFormData: MultipartFormData, params: [String: Any]?) {
            guard let params = params else {
                return
            }
            
            for (key, value) in params {
                if let temp = value as? UIImage,
                   let data = temp.jpegData(compressionQuality: 1.0) {
                    if let fileName = self.api.fileName {
                        multipartFormData.append(data, withName: key, fileName: fileName, mimeType: "image/jpeg")
                        continue
                    }
                    multipartFormData.append(data, withName: key, fileName: "\(key).jpg", mimeType: "image/jpg")
                    continue
                }
                
                if let temp = value as? String,
                          let data = temp.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                    continue
                }
                
                if let temp = value as? Int,
                          let data = "\(temp)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                    continue
                }
                
                if let temp = value as? URL,
                   temp.startAccessingSecurityScopedResource() {
                    if let data = try? Data(contentsOf: temp.asURL()) {
                        multipartFormData.append(data, withName: key, fileName: self.getNameFile(url: temp), mimeType: self.mimeTypeForPath(url: temp))
                    }
                    temp.stopAccessingSecurityScopedResource()
                    continue
                }
            }
        }
    
    fileprivate func mimeTypeForPath(url: URL) -> String {
        let url = NSURL(fileURLWithPath: url.path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    func getNameFile(url: URL) -> String? {
        return url.lastPathComponent
    }
}

struct JSONArrayEncoding: ParameterEncoding {
    private let array: [Parameters]

    init(array: [Parameters]) {
        self.array = array
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        let data = try JSONSerialization.data(withJSONObject: array, options: [])

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        urlRequest.httpBody = data

        return urlRequest
    }
}
