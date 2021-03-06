//
// Endpoint.swift
// Copyright (c) 2014 NGeen
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class ApiEndpoint: NSObject {
    
    var contentType: ContentType? = nil
    var httpMethod: HttpMethod? = nil
    var modelClass: NSObject.Type? = nil
    var path: String? = nil
    
    override init () {}
    
    convenience init(contentType: ContentType, httpMethod: HttpMethod, path: String) {
        self.init()
        self.contentType = contentType
        self.httpMethod = httpMethod
        self.path = path
    }
    
    convenience init(contentType: ContentType, httpMethod: HttpMethod, modelClass: NSObject.Type, path: String) {
        self.init(contentType: contentType, httpMethod: httpMethod, path: path)
        self.modelClass = modelClass
    }
    
//MARK: Class methods
    
    class func endpointWithPath(path: String, HttpMethod httpMethod: HttpMethod, ModelClass modelClass: NSObject.Type) -> ApiEndpoint {
        return ApiEndpoint(contentType: ContentType.json, httpMethod: httpMethod, modelClass: modelClass, path: path)
    }
    
    class func endpointWithPath(path: String, contentType: ContentType, HttpMethod httpMethod: HttpMethod, ModelClass modelClass: NSObject.Type) -> ApiEndpoint {
        return ApiEndpoint(contentType: contentType, httpMethod: httpMethod, modelClass: modelClass, path: path)
    }
    
    class func keyForModelClass(modelClass: AnyClass?, httpMethod method: HttpMethod?) -> String {
        return "\(modelClass?)_\(method?.toRaw())"
    }
    
//MARK: Instance methods
    
    func key() -> String {
        return ApiEndpoint.keyForModelClass(self.modelClass, httpMethod: self.httpMethod)
    }
    
}
