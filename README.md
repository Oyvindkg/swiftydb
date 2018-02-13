![Logo](http://i.imgur.com/uQhXJLJ.png)

There are many libraries out there that aims to help developers easily create and use SQLite databases. 
Unfortunately developers still have to get bogged down in simple tasks such as writing table definitions 
and SQL queries. SwiftyDB automatically handles everything you don't want to spend your time doing.

[![CI Status](https://img.shields.io/travis/Oyvindkg/swiftydb/master.svg?style=flat)](https://travis-ci.org/Oyvindkg/swiftydb)
[![Version](https://img.shields.io/cocoapods/v/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![License](https://img.shields.io/cocoapods/l/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Swift](https://img.shields.io/badge/swift-2-brightgreen.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)

You can find the [documentation here](http://oyvindkg.github.io/swiftydb/docs/)

**Content**<br />
[Features](#features)<br />
[Usage](#usage)<br />
&emsp; [Access the database](#accessTheDatabase)<br />
&emsp;&emsp; [Synchronous access](#syncAccess)<br />
&emsp;&emsp; [Aynchronous access](#asyncAccess)<br />
&emsp; [Result format](#resultFormat)<br />
&emsp; [Filter results](#filterResults)<br />
&emsp; [Defining your classes](#definingYourClasses)<br />
&emsp;&emsp; [Primary keys](#primaryKeys)<br />
&emsp;&emsp; [Ignoring properties](#ignoringProperties)<br />
&emsp; [How to retrieve objects](#howToRetrieveObjects)<br />
[Installation](#installation)<br />
[License](#license)

### <a name="features">Features</a>
- [x] Creates and updates databases, tables, and records automatically
- [x] Supports optional types
- [x] Simple equality-based filtering
- [x] Thread safe database operations
- [x] Supports asynchronous database access
- [x] 100% documented
- [x] Complex filtering
- [x] Store collections
- [ ] Store nested objects
- [ ] Automated migration
- [ ] Custom indices

## <a name="usage">Usage</a>

Almost pure plug and play. All you have to do is create an instance of SwiftyDB, and everything will be handled automagically behind the scenes 🎩

### <a name="accessTheDatabase">Access the database</a>

Tell SwiftyDB what you want to call your database, and you are ready to go. If a database with the provided name does not exist, it will be created.

```Swift
let database = SwiftyDB(databaseName: "dogtopia")
```

#### <a name="syncAccess">Synchronous access</a>

##### <a name="syncAddOrUpdate">Add or update a record</a>
```Swift
database.addObject(dog, update: true)
database.addObjects(dogs, update: true)
````

##### <a name="syncRetrieveData">Retrieve data</a>

Retrieve data with datatypes matching those of the type's properties
```Swift
/* Array of dictionaries representing `Dog` objects from the database */
database.dataForType(Dog.self)
database.dataForType(Dog.self, matchingFilters: ["id": 1])
````
Dog data example
```Swift
[
    "id": 1,                // As an Int
    "name": "Ghost",        // As a String
    "owner": "John Snow",   // As a String
    "birth": August 6, 1996 // As an NSDate
]
```

##### <a name="syncRetrieveObjects">Retrieve objects</a>

Retrieve objects with data from the database
```Swift
database.objectsForType(Dog.self)
database.objectsForType(Dog.self, matchingFilters: ["id": 1])
````

> In order to retrieve objects, Swift currently imposes some [restictions on your classes](#howToRetrieveObjects)

##### <a name="syncDelete">Delete records</a>
```Swift
database.deleteObjectsForType(Dog.self)
database.deleteObjectsForType(Dog.self, matchingFilters: ["name": "Max"])
```

#### <a name="asyncAccess">Asynchronous access</a>

##### <a name="asyncAddOrUpdate">Add or update a record</a>
```Swift
database.asyncAddObject(dog) { (result) -> Void in
    if let error = result.error {
        // Handle error
    }
}
````

##### <a name="asyncRetrieveData">Retrieve data</a>

Retrieve data with datatypes matching those of the type's properties
```Swift
database.asyncDataForType(Dog.self) { (result) -> Void in
    if let data = result.value {
        // Process data
    }
}
````

##### <a name="asyncRetrieveObjects">Retrieve objects</a>

Retrieve data with datatypes matching those of the type's properties
```Swift
database.asyncObjectsForType(Dog.self) { (result) -> Void in
    if let objects = result.value {
        // Handle objects
    }
}
````

> In order to retrieve objects, Swift currently imposes some [restictions on your classes](#howToRetrieveObjects)

##### <a name="asyncDelete">Delete records</a>
```Swift
database.asyncDeleteObjectsForType(Dog.self) { (result) -> Void in
    if let error = result.error {
        // Handle error
    }
}
```

### <a name="filterResults">Filter results</a>

`Filter` objects are used to filter queries. All filters are translated to SQLite before querying the database.

#### <a name="simpleFilters">Simple filters</a>
The easiest way to define your filter, is by using a dictionary:
```Swift
database.objectsForType(Dog.self, matchingFilters: ["name": "Ghost"])
```
All objects with the name 'Ghost' will be retrieved

#### <a name="complexFilters">Complex filters</a>

For more complex filters, you can instantiate a new `Filter` object, and define your filters

```Swift
let filter = Filter.equal("name", value: "Ghost")
                   .like("owner", pattern: "J_h%")
                   .greaterThan("id", value: 3)

database.objectsForType(Dog.self, matchingFilters: filter)
```

See all available filters in the [documentation](http://oyvindkg.github.io/swiftydb/docs/Classes/Filter.html).

> It is not possible to filter results using the content of stored collections as these are stored as blobs in the database

### <a name="resultFormat">Result format</a>

All queries returns the result as a `Result`. It will either be a `.Success` wrapping data from the query, or an `.Error` wrapping the thrown error.

```Swift
enum Result<A: Any>: BooleanType {
    case Success(A)
    case Error(ErrorType)
    
    var data: A?
    var error: ErrorType?
    var isSuccess: Bool
    var boolValue: Bool {return isSuccess}
}
```

#### <a name="handlingResults">Handling results</a>
The implementation of `Result` makes it a versatile tool that can (hopefully 😬) be adapted to your programming style

##### <a name="handlingValues">Handling values</a>
You can capture the data from a query with the `value` property. If an error was thrown, this property will be `nil`.

```Swift
if let object = result.value {
    // Process objects
}
```

##### <a name="handlingErrors">Handling errors</a>
You can detect an error like this
```Swift
if !database.addObject(dog) {
    // An error occured
}
```
or capture it using the `error` property like this

```Swift
if let error = result.error {
    // Process objects
}
```
If you want to, you can even bring your sledgehammer and start cracking some nuts
```Swift
switch result {
    case .Success(let value):
        // Process value
    case .Error(let error):
        // Handle error
}
```

### <a name="definingYourClasses">Defining your classes</a>

Let's use this simple `Dog` class as an example

```Swift
class Dog {
    var id: Int?
    var name: String?
    var owner: String?
    var birth: NSDate?
}
```

All objects must conform to the `Storable` protocol.

```Swift
public protocol Storable {
    init()
}
```

By adding the `Storable` protocol and implementing `init()`, you are already ready to go.

```Swift
class Dog: Storable {
    var id: Int?
    var name: String?
    var owner: String?
    var birth: NSDate?
    
    required init() {}
}
```

> SwiftyDB supports inheritance. Valid properties from both the class and the superclass will be stored automatically

##### <a name="primaryKeys">Primary keys</a>
It is recommended to implement the `PrimaryKeys` protocol. The `primaryKeys()` method should return a set of property names which uniquely identifies an object.

```Swift
extension Dog: PrimaryKeys {
    class func primaryKeys() -> Set<String> {
        return ["id"]
    }
}
```

##### <a name="ignoringProperties">Ignoring properties</a>
If your class contains properties that you don't want in your database, you can implement the `IgnoredProperties` protocol.

```Swift
extension Dog: IgnoredProperties {
    class func ignoredProperties() -> Set<String> {
        return ["name"]
    }
}
```
> Properties with datatypes that are not part of the `Value` protocol, will automatically be ignored by SwiftyDB

### <a name="howToRetrieveObjects">How to retrieve objects</a>

SwiftyDB can also retrieve complete objects with all properties assigned with data from the database. In order to achieve this, the type must be a subclass of `NSObject`, and all property types must be representable in in Objective-C. This is because pure Swift currently does not support dynamic assignment of properties. 

**Dynamic property types**
- [x] `Int`
- [x] `UInt`
- [x] `Float`
- [x] `Double`
- [x] `Bool`
- [x] `String` / `String?`
- [x] `NSNumber` / `NSNumber?`
- [x] `NSString` / `NSString?`
- [x] `NSDate` / `NSDate?`
- [x] `NSData` / `NSData?`


An updated Dog class that can be used to retrieve complete objects from the database:

```Swift
class Dog: NSObject, Storable {
    var id: NSNumber? // Notice that 'Int?' is not supported. Use NSNumber? instead
    var name: String?
    var owner: String?
    var birth: NSDate?
    
    override required init() {
        super.init()
    }
}
```

## <a name="installation">Installation</a>

SwiftyDB is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyDB"
```

## Author

Øyvind Grimnes, oyvindkg@yahoo.com

## <a name="License">License</a>

SwiftyDB is available under the MIT license. See the LICENSE file for more info.
