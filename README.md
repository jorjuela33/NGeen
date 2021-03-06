NGeen
=====

NGeen is a delightful library for swift. It's built based on factory design pattern, extending the powerful high-level networking and database abstractions built into Cocoa.

Choose NGeen for your next project, or migrate over your existing projects—you'll be happy you did!

## How To Get Started

- [Download NGeen](https://github.com/NGeenLibraries/NGeen/archive/master.zip) and try out.

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Architecture

#### Base
- Constants
	- Constants
- DataTypes
	- DataTypes
- Protocols
	- Protocols	

#### Cache
- DiskCache
	- DiskCache
- Entity
	- Entity
- Cache

#### Model

- Model

#### Network
- Request	
	- Request

#### Query
- Api	
	- ApiQuery
- DataBase	
	- DataBaseQuery

#### Store
- Api	
	- Config
		- ApiStoreConfiguration	
	- Endpoint
		- ApiEndpoint
	- ApiStore
- DataBase	
	- DataBaseStore

## Usage

### HTTP Request Operation 

#### `GET` Request

```swift 
var endPoint: ApiEndpoint = ApiEndpoint(contentType: ContentType.json, httpMethod: HttpMethod.get, path: "resources.json")
ApiStore.defaultStore().setEndpoint(endPoint)
var apiQuery: ApiQuery = ApiStore.defaultStore().createQuery()
apiQuery.read(completionHandler: {(object, error) in
	println("RESPONSE: ", object)
})
```

#### `POST` URL-Form-Encoded Request

```swift
var endPoint: ApiEndpoint = ApiEndpoint(contentType: ContentType.urlEnconded, httpMethod: HttpMethod.post, path: "resources.json")
ApiStore.defaultStore().setBodyItem("foo", forKey: "bar")
ApiStore.defaultStore().setEndpoint(endPoint)
var apiQuery: ApiQuery = ApiStore.defaultStore().createQuery()
apiQuery.create(completionHandler: {(object, error) in
	println("RESPONSE: ", object)
})
```

#### `POST` Multi-Part Request

```swift
ApiStore.defaultStore().setBodyItem("foo", forKey: "bar")
ApiStore.defaultStore().setFileData(data, forName: "image", fileName: "image.jpg", mimeType: "image/jpg")
var apiQuery: ApiQuery = ApiStore.defaultStore().createQuery()
apiQuery.create(completionHandler: {(object, error) in
	println("RESPONSE: ", object)
})
```

---

### Request Serialization

```swift
var apiStoreConfiguration: ApiStoreConfiguration = ApiStoreConfiguration(headers: headers, host: "example.com", httpProtocol: "http")
var parameters: Dictionary<String, String> = ["foo": "bar", "baz1": "1", "baz2": "2", "baz3": "3"]
```

#### Query String Parameter Encoding

###### Using the Api Store adding a dictionary of items

```swift
ApiStore.defaultStore().setPathItems(parameters)
```
###### Using the Api Store adding item by item

```swift
ApiStore.defaultStore().setQueryItem("foo", forKey: "bar")
ApiStore.defaultStore().setQueryItem("1", forKey: "baz1")
ApiStore.defaultStore().setQueryItem("2", forKey: "baz2")
ApiStore.defaultStore().setQueryItem("3", forKey: "baz3") 
```
###### Using the Api Query adding a dictionary of items

```swift
apiQuery.setQueryItems(parameters)
```

###### Using the Api Query adding item by item

```swift
apiQuery.setQueryItem("foo", forKey: "bar")
apiQuery.setQueryItem("1", forKey: "baz1")
apiQuery.setQueryItem("2", forKey: "baz2")
apiQuery.setQueryItem("3", forKey: "baz3")
```
```swift
GET http://example.com?foo=bar&baz1=1&baz2=2&baz3=3
```

#### URL Form Parameter Encoding

```swift
ApiStore.defaultStore().setBodyItems(parameters)
apiQuery.create(completionHandler: {(object, error) in
	println("RESPONSE: ", object)
})
```

    POST http://example.com/
    Content-Type: application/x-www-form-urlencoded

    foo=bar&baz1=1&baz2=2&baz3=3

#### JSON Parameter Encoding

```swift
var endPoint: ApiEndpoint =  ApiEndpoint(contentType: ContentType.json, httpMethod: HttpMethod.post, path: "resources.json")
ApiStore.defaultStore().setEndpoint(endPoint)
ApiStore.defaultStore().setBodyItems(parameters)
apiQuery.create(completionHandler: {(object, error) in
	println("RESPONSE: ", object)
})
```

    POST http://example.com/
    Content-Type: application/json

    {"foo": "bar", "baz": [1,2,3]}

---

## License

NGeen is available under the MIT license. See the LICENSE file for more info.