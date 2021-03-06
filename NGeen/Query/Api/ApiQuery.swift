//
// ApiQuery.swift
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

class ApiQuery: NSObject, QueryProtocol, RequestDelegate {

    internal var config: ConfigurationStoreProtocol? {
        get {
            return __config
        }
        set(config) {
            __config = config as? ApiStoreConfiguration
        }
    }
    private struct NGImageBodyPart {
        
        var data: NSData
        var fileName: String
        var mimeType: String
        var name: String

        init(bodies: NSDictionary) {
            self.data = bodies["data"] as NSData!
            self.fileName = bodies["fileName"] as String!
            self.mimeType = bodies["mimeType"] as String!
            self.name = bodies["name"] as String!
        }
    }
    private var __config: ApiStoreConfiguration?
    private var endPoint: ApiEndpoint
    private var urlComponents: NSURLComponents = NSURLComponents(string: "")
    
    weak var delegate: ApiQueryDelegate?
    
//MARK: Constructor
    
    init(configuration: ConfigurationStoreProtocol, endPoint: ApiEndpoint) {
        self.endPoint = endPoint
        self.urlComponents.path = (self.endPoint.path != nil ? self.endPoint.path : "")
        super.init()
        self.config = configuration
        self.urlComponents.scheme = self.__config!.httpProtocol
        self.urlComponents.host = self.__config!.host
    }
    
// MARK: Instance methods    
    
    /**
    * The function return the body items
    *
    * @param no need params.
    *
    * @return Dictionary
    */
    
    func bodyItems() -> NSDictionary {
        return self.__config!.bodyItems
    }
    
    /**
    * The function return the body
    *
    * @param no need params.
    *
    * @return String
    */
    
    func body() -> String {
        if self.endPoint.contentType == ContentType.json {
            let data: NSData = NSJSONSerialization.dataWithJSONObject(self.__config!.bodyItems, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            return  NSString(data: data, encoding: NSUTF8StringEncoding)
        } else if self.endPoint.contentType == ContentType.multiPartForm {
            return self.serializeMultipartDictionary(self.__config!.bodyItems)
        }
        return self.serializeDictionary(self.__config!.bodyItems)
    }
    
    /**
    * The function return the cache request policy for a server configuration
    *
    * @param policy The cache policy.
    *
    * @return NSURLRequestCachePolicy
    */
    
    func cachePolicy() -> NSURLRequestCachePolicy {
        return self.__config!.cachePolicy
    }
    
    /**
    * The function return the cache request policy for a server configuration
    *
    * @param policy The cache policy.
    *
    * @return NSURLRequestCachePolicy
    */
    
    func cacheStoragePolicy() -> NSURLCacheStoragePolicy {
        return self.__config!.cacheStoragePolicy
    }
    
    /**
    * The function set the cache storage policy for a server configuration
    *
    * @param policy The cache policy.
    *
    */
    
    func setCacheStoragePolicyForServer(policy: NSURLCacheStoragePolicy) {
        self.__config!.cacheStoragePolicy = policy
    }
    
    /**
    *  The function return the configuration for the api query
    *
    *  @return ApiStoreConfig
    */
    
    func configuration() -> ApiStoreConfiguration {
        return self.__config!
    }
    
    /**
    * The function return the http headers
    *
    * @param no need params.
    *
    * @return Dictionary
    */
    
    func httpHeaders() -> Dictionary<String, String> {
        return self.__config!.headers
    }
    
    /**
    * The function return model path
    *
    * @param no need params.
    *
    * @return String
    */
    
    func modelsPath() -> String {
        return self.__config!.modelsPath
    }
    
    /**
    * The function return the path items
    *
    * @param no need params.
    *
    * @return Dictionary
    */
    
    func pathItems() -> Dictionary<String, String> {
        return self.__config!.pathItems
    }
    
    /**
    * The function return the full path for the components
    *
    * @param no need params.
    *
    * @return String
    */
    
    func path() -> String {
        return self.urlComponents.path
    }
    
    /**
    * The function return the query string
    *
    * @param no need params.
    *
    * @return String
    */
    
    func query() -> String {
        return self.urlComponents.query
    }
    
    func response() -> ResponseType {
        return self.__config!.responseType
    }
    
    /**
    * The function store the body item in a local dictionary
    *
    * @param item The body item.
    * param key The key for the given item.
    *
    */
    
    func setBodyItem(item: AnyObject, forKey key: String) {
        self.__config!.bodyItems[key] = item
    }
    
    /**
    * The function store the body the items in a local dictionary
    *
    * @param items The body items for the request.
    *
    */
    
    func setBodyItems(items: NSDictionary) {
        self.__config!.bodyItems.addEntriesFromDictionary(items)
    }
    
    /**
    * The function set the cache request policy for a server configuration
    *
    * @param policy The cache policy.
    *
    */
    
    func setCachePolicy(policy: NSURLRequestCachePolicy) {
        self.__config!.cachePolicy = policy
    }
    
    /**
    * The function set the cache storage policy for a server configuration
    *
    * @param policy The cache policy.
    *
    */
    
    func setCacheStoragePolicy(policy: NSURLCacheStoragePolicy) {
        self.__config!.cacheStoragePolicy = policy
    }
    
    /**
    * The function set the data for a given image
    *
    * @param data The data with the contents of the image.
    * @param name The name for the image in the body.
    * @param file The file name for the image in the body.
    * @param mime The mime type of the image.
    *
    */
    
    func setFileData(data: NSData, forName name: String, fileName file: String, mimeType mime: String) {
        assert(file != nil, "You should provide the file name for the file", file: __FILE__, line: __LINE__)
        assert(name != nil, "You should provide a name for the file", file: __FILE__, line: __LINE__)
        assert(mime != nil, "You should provide a mime type for the file", file: __FILE__, line: __LINE__)
        self.__config!.bodyItems.setObject(["data": data, "fileName": file, "name": name, "mimeType": mime], forKey: kDefaultImageKeyData)
    }
    
    /**
    * The function set a value for the local headers
    *
    * @param header The value for the header.
    * @param key The value for the header field.
    *
    */
    
    func setHeader(header: String, forKey key: String) {
        self.__config!.headers[key] = header
    }
    
    /**
    * The function set the headers in a local dictionary
    *
    * @param headers The headers for the request.
    *
    */
    
    func setHeaders(headers: Dictionary<String, String>) {
        self.__config!.headers += headers
    }

    /**
    * The function set the model path for the api response
    *
    * @param path The path of the models in the api response.
    *
    */
    
    func setModelsPath(path: String) {
        self.__config?.modelsPath = path
    }
   
    /**
    * The function store a path item in a local dictionary
    *
    * @param item The path item.
    * @param key The key for the given item.
    *
    */
    
    func setPathItem(item: String, forKey key: String) {
        self.__config!.pathItems[key] = item
        self.urlComponents.path = "\(self.urlComponents.path)/\(item)"
    }
    
    /**
    * The function store the path items in a local dictionary
    *
    * @param items The path items.
    *
    */
    
    func setPathItems(items: Dictionary<String, String>) {
        println(self.__config!.pathItems)
        self.__config!.pathItems += items
        println(self.__config!.pathItems)
        for (key, value) in items {
            self.urlComponents.path = "\(self.urlComponents.path)/\(value)"
        }
    }
    
    /**
    * The function store a query item in a local dictionary
    *
    * @param item The query item.
    * @param key The key for the given query item.
    *
    */
    
    func setQueryItem(item: String, forKey key: String) {
        self.__config!.queryItems[key] = item
        self.urlComponents.query = (!self.urlComponents.query ? "": "\(self.urlComponents.query)&")+"\(key)=\(item)"
    }
    
    /**
    * The function store the query items in a local dictionary
    *
    * @param items The query items.
    *
    */
    
    func setQueryItems(items: Dictionary<String, String>) {
        self.__config!.queryItems += items
        for (key, value) in items {
            self.urlComponents.query = (!self.urlComponents.query ? "": "\(self.urlComponents.query)&")+"\(key)=\(value)"
        }
    }
    
    /**
    * The function set the response type for the query
    *
    * @param type The response type.
    *
    */
    
    func setResponseType(type: ResponseType) {
        self.__config!.responseType = type
    }
    
// MARK: Persistence Protocol
    
    /**
    * The function call set the http method and call the startRequest function
    *
    * @param completionHandler The closure to be called when the function end.
    *
    */
    
    func create(completionHandler closure: NGeenClosure) {
        self.endPoint.httpMethod = HttpMethod.post
        self.startRequest(closure)
    }
    
    /**
    * The function call set the http method and call the startRequest function
    *
    * @param completionHandler The closure to be called when the function end.
    *
    */
    
    func delete(completionHandler closure: NGeenClosure) {
        self.endPoint.httpMethod = HttpMethod.delete
        self.startRequest(closure)
    }
    
    /**
    * The function call set the http method and call the startRequest function
    *
    * @param completionHandler The closure to be called when the function end.
    *
    */
    
    func read(completionHandler closure: NGeenClosure) {
        self.endPoint.httpMethod = HttpMethod.get
        self.startRequest(closure)
    }
    
    /**
    * The function call set the http method and call the startRequest function
    *
    * @param completionHandler The closure to be called when the function end.
    *
    */
    
    func update(completionHandler closure: NGeenClosure) {
        self.endPoint.httpMethod = HttpMethod.put
        self.startRequest(closure)
    }
    
// MARK: Private methods       
    
    /**
    * The function configure the body for the request
    *
    * @param request The instance of the request to set the body.
    *
    */
    
    private func bodyForRequest(inout request: Request) {
        if (self.__config!.bodyItems.count > 0) {
            assert(self.endPoint.httpMethod != HttpMethod.delete, "You can`t set a body for http delete method", file: __FILE__, line: __LINE__)
            assert(self.endPoint.httpMethod != HttpMethod.get, "You can`t set a body for http get method", file: __FILE__, line: __LINE__)
            if self.endPoint.contentType == ContentType.image {
                assert(self.__config!.bodyItems[kDefaultImageKeyData] != nil, "The image data should not be null", file: __FILE__, line: __LINE__ )
                let imageBodyPart: NGImageBodyPart = NGImageBodyPart(bodies: self.__config!.bodyItems[kDefaultImageKeyData] as NSDictionary)
                request.body = imageBodyPart.data
                self.setHeader(imageBodyPart.mimeType, forKey: "Content-Type")
            } else if self.endPoint.contentType == ContentType.json {
                request.body = NSJSONSerialization.dataWithJSONObject(self.__config!.bodyItems, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            } else if self.endPoint.contentType == ContentType.multiPartForm {
                if let body = self.serializeMultipartDictionary(self.__config!.bodyItems).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
                    request.body = body
                } else {
                    assert(false, "Unable to serialize the multipart body", file: __FILE__, line: __LINE__)
                }
            } else if self.endPoint.contentType == ContentType.textPlain {
                assert(self.__config!.bodyItems[kDefaultFileKeyData] != nil, "The file data should not be null", file: __FILE__, line: __LINE__ )
                request.body = self.__config!.bodyItems[kDefaultFileKeyData].dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
            } else {
                if let body = self.serializeDictionary(self.__config!.bodyItems).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
                    request.body = body
                } else {
                    assert(false, "Unable to serialize the form body", file: __FILE__, line: __LINE__)
                }
            }
            request.setValue(request.body.length.description, forHTTPHeaderField: "Content-Length")
        }
    }
    
    /**
    * The function configure the request
    *
    * @param request The instance of the request to configure.
    *
    */
    
    private func configureRequest(inout request: Request) {
        request.cachePolicy = self.__config!.cachePolicy
        request.cacheStoragePolicy = self.__config!.cacheStoragePolicy
        request.delegate = self
        request.setValue(self.endPoint.contentType!.toRaw(), forHTTPHeaderField: "Content-Type")
        for (key, value) in self.__config!.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        self.bodyForRequest(&request)
    }
    
    /**
    * The function serialize a dictionary into a string params for url encode form
    *
    * @param dictionary The dictionary with the params to serialize.
    *
    * @return String
    */
    
    private func serializeDictionary(dictionary: NSDictionary) -> String {
        var params: String = ""
        var format: String = ""
        dictionary.enumerateKeysAndObjectsUsingBlock({(key, value, stop) in
            if value is String {
                params = "\(params)\(format)\(key)=\((value as String).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))"
            }
            format = "&"
        })
        return params
    }
    
    /**
    * The function serialize the dictionary in multipart form
    *
    * @param dictionary The dictionary with the params to serialize.
    *
    * @return String
    */
    
    private func serializeMultipartDictionary(dictionary: NSDictionary) -> String {
        assert(self.__config!.bodyItems[kDefaultImageKeyData], "The multipart form should have at least a image in the body", file: __FUNCTION__, line: __LINE__)
        let boundary: String = "--Boundary+\(CFAbsoluteTimeGetCurrent())\r\n"
        var params: String = ""
        dictionary.enumerateKeysAndObjectsUsingBlock({(key, value, stop) in
            if (key as String) == kDefaultImageKeyData {
                let imageBodyPart: NGImageBodyPart = NGImageBodyPart(bodies: dictionary[kDefaultImageKeyData] as NSDictionary)
                params = "\(params)\(boundary) Content-Disposition: form-data; name=\"\(imageBodyPart.name)\"; filename=\"\(imageBodyPart.fileName)\"\r\n Content-Type: \(imageBodyPart.mimeType)\r\n\r\n \(imageBodyPart.data)\r\n"
            } else {
                params = "\(params)\(boundary) Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n \(value)\r\n"
            }
        })
        params = "\(params)\(boundary)--\r\n"
        return params
    }
    
    /**
    * The function make the configuration and start the request
    *
    * @param completionHandler The closure to be called when the request end.
    *
    */
    
    private func startRequest(completionHandler closure: NGeenClosure) {
        assert(self.urlComponents.URL != nil, "The url cant be null", file: __FUNCTION__, line: __LINE__)
        var request: Request = Request(httpMethod: self.endPoint.httpMethod!.toRaw(), url: self.urlComponents.URL)
        self.configureRequest(&request)
        request.sendAsynchronous(completionHandler: {(data, urlResponse, error) in
            if closure != nil {
                closure(object: self.response(data), error: error)
            }
        })
    }
    
    /**
    * The function configure the response for the current request
    *
    * @param data The data from the response.
    *
    */
    
    private func response(data: NSData) -> AnyObject {
        if self.__config!.responseType == ResponseType.dictionary {
            if let jsonDictionary: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) {
                return jsonDictionary
            }
            return NSString(data: data, encoding: NSUTF8StringEncoding)
        } else if self.__config!.responseType == ResponseType.models {
            assert(!self.__config!.modelsPath.isEmpty, "You should set the models path for the response type", file: __FUNCTION__, line: __LINE__)
            if let jsonDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
                var dictionaries: Array<NSDictionary> = jsonDictionary.valueForKeyPath(self.__config!.modelsPath) as Array<NSDictionary>
                var models: Array<AnyObject> = Array<AnyObject>()
                for value in dictionaries {
                    var model = self.endPoint.modelClass!() as Model
                    model.fill(value as Dictionary<String, AnyObject>)
                    models.append(model)
                }
                return models
            }
        } else if self.__config!.responseType == ResponseType.string {
            return NSString(data: data, encoding: NSUTF8StringEncoding)
        }
        return data
    }
    
//MARK: Request delegate
    
    func cachedResponseForUrl(url: NSURL, cachedData data: NSData) {
        if self.delegate != nil && self.delegate!.respondsToSelector("cachedResponseForUrl:cachedData:")  {
            self.delegate!.cachedResponseForUrl!(url, cachedData: self.response(data))
        }
    }
    
}
