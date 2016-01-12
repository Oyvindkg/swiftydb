![alt text] (http://i.imgur.com/uQhXJLJ.png?1 "Logo")

There are many libraries out there that aims to help developers easily create and use SQLite databases. 
Unfortunately developers still have to get bogged down in simple tasks such as writing table definitions 
and SQL queries. SwiftyDB automatically handles everything you don't want to spend your time doing.

[![CI Status](http://img.shields.io/travis/Oyvindkg/swiftydb.svg?style=flat)](https://travis-ci.org/Oyvindkg/swiftydb)
[![Version](https://img.shields.io/cocoapods/v/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![License](https://img.shields.io/cocoapods/l/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)

### Features
- [x] Creates and updates databases, tables, and records automatically
- [x] Store any native Swift type
- [x] Supports optional types
- [x] Simple equality-based filtering
- [x] Thread safe database operations
- [ ] Complex filtering
- [ ] Store nested objects
- [ ] Store collections

## Usage
Almost pure plug and play. All you have to do is create an instance of SwiftyDB, and everything will be handled automagically behind the scenes 🎩

```Swift
let database = SwiftyDB(databaseName: "dogtopia")
```
**Add or update a record**
```Swift
try database.addObject(dog, update: true)
try database.addObjects(dogs, update: true)
````

**Retrieve data**

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
**Delete records**
```Swift
try database.deleteObjectsForType(Dog.self)
try database.deleteObjectsForType(Dog.self, matchingFilters: ["name": "Max"])
```

### Defining your classes
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

##### Primary keys
It is recommended you can implement the `PrimaryKeys` protocol. The `primaryKeys()` method should return a set of property names which uniquely identifies an object.

```Swift
extension Dog: PrimaryKeys {
    class func primaryKeys() -> Set<String> {
        return ["id"]
    }
}
```

##### Ignoring properties
If your class contains properties that you don't want in your database, you can implement the `IgnoredProperties` protocol.

```Swift
extension Dog: IgnoredProperties {
    class func ignoredProperties() -> Set<String> {
        return ["name"]
    }
}
```
> Properties with datatypes that are not part of the `SQLiteValue` protocol, as defined by [TinySQLite](https://github.com/Oyvindkg/tinysqlite/blob/master/Pod/Classes/DatabaseConnection.swift), will automatically be ignored by SwiftyDB

### Retrieve objects
SwiftyDB can also retrieve complete objects with all properties assigned with data from the database. In order to achieve this, the type must be a subclass of `NSObject`, and all property types must be representable in in Objective-C. This is because pure Swift does not support dynamic, name-based assignment of properties. 

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

#### Defining your dynamic classes

Updated Dog class subclassing `NSObject`, and using valid property types:

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

**Retrieve objects**

```Swift
/* Returns an array of Dog objects */
try database.objectsForType(Dog.self)
try database.objectsForType(Dog.self, matchingFilters: ["name": "Max"])
```

## Installation

SwiftyDB is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyDB"
```

## Author

Øyvind Grimnes, oyvindkg@yahoo.com

## License

SwiftyDB is available under the MIT license. See the LICENSE file for more info.
