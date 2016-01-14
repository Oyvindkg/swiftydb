![alt text] (http://i.imgur.com/uQhXJLJ.png?1 "Logo")

There are many libraries out there that aims to help developers easily create and use SQLite databases. 
Unfortunately developers still have to get bogged down in simple tasks such as writing table definitions 
and SQL queries. SwiftyDB automatically handles everything you don't want to spend your time doing.

[![CI Status](https://img.shields.io/travis/Oyvindkg/swiftydb/dev.svg?style=flat)](https://travis-ci.org/Oyvindkg/swiftydb)
[![Version](https://img.shields.io/cocoapods/v/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![License](https://img.shields.io/cocoapods/l/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)

**Content**<br />
[Features](#features)<br />
[Usage](#usage)<br />
&emsp; [Access the database](#accessTheDatabase)<br />
&emsp;&emsp; [Synchronous access](#syncAccess)<br />
&emsp;&emsp;&emsp; [Add or update data](#syncAddOrUpdate)<br />
&emsp;&emsp;&emsp; [Retrieve data](#syncRetrieveData)<br />
&emsp;&emsp;&emsp; [Retrieve objects](#syncRetrieveObjects)<br />
&emsp;&emsp;&emsp; [Delete data](#syncDelete)<br />
&emsp;&emsp; [Aynchronous access](#asyncAccess)<br />
&emsp;&emsp;&emsp; [Add or update data](#asyncAddOrUpdate)<br />
&emsp;&emsp;&emsp; [Retrieve data](#asyncRetrieveData)<br />
&emsp;&emsp;&emsp; [Retrieve objects](#asyncRetrieveObjects)<br />
&emsp;&emsp;&emsp; [Delete data](#asyncDelete)<br />
&emsp; [Defining your classes](#definingYourClasses)<br />
&emsp;&emsp; [Primary keys](#primaryKeys)<br />
&emsp;&emsp; [Ignoring properties](#ignoringProperties)<br />
&emsp; [How to retrieve objects](#howToRetrieveObjects)<br />
[Installation](#installation)<br />
[License](#license)

### <a name="features">Features</a>
- [x] Creates and updates databases, tables, and records automatically
- [x] Store any native Swift type
- [x] Supports optional types
- [x] Simple equality-based filtering
- [x] Thread safe database operations
- [x] Supports asynchronous database access
- [ ] Complex filtering
- [ ] Store nested objects
- [ ] Store collections

## <a name="usage">Usage</a>

Almost pure plug and play. All you have to do is create an instance of SwiftyDB, and everything will be handled automagically behind the scenes 🎩

### <a name="accessTheDatabase">Access the database</a>
Tell SwiftyDB what you wan to call your database, and you are ready to go. If a database with the provided name does not exist, it will be created.

```Swift
let database = SwiftyDB(databaseName: "dogtopia")
```

#### <a name="syncAccess">Synchronous access</a>

##### <a name="syncAddOrUpdate">Add or update a record</a>
```Swift
try database.addObject(dog, update: true)
try database.addObjects(dogs, update: true)
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
try database.objectsForType(Dog.self)
try database.objectsForType(Dog.self, matchingFilters: ["id": 1])
````

> In order to retrieve objects, Swift currently imposes some [restictions on your classes](#howToRetrieveObjects)

##### <a name="syncDelete">Delete records</a>
```Swift
try database.deleteObjectsForType(Dog.self)
try database.deleteObjectsForType(Dog.self, matchingFilters: ["name": "Max"])
```

#### <a name="asyncAccess">Asynchronous access</a>
Asynchronous methods takes a closure as parameter. This is used to return the result of the query as a `Result`

```Swift
enum Result<A: Any> {
    var data: A?
    var error: ErrorType?
    
    case Success(A)
    case Error(ErrorType)
}
```

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
    if let data = result.data {
        // Handle data
    }
}
````

##### <a name="asyncRetrieveObjects">Retrieve objects</a>

Retrieve data with datatypes matching those of the type's properties
```Swift
database.asyncObjectsForType(Dog.self) { (result) -> Void in
    if let data = result.data {
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
It is recommended you can implement the `PrimaryKeys` protocol. The `primaryKeys()` method should return a set of property names which uniquely identifies an object.

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
> Properties with datatypes that are not part of the `SQLiteValue` protocol, as defined by [TinySQLite](https://github.com/Oyvindkg/tinysqlite/blob/master/Pod/Classes/DatabaseConnection.swift), will automatically be ignored by SwiftyDB

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
