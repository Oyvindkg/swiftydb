# !! Work in progress !!

![alt text] (http://i.imgur.com/uQhXJLJ.png?1 "Logo")

There are many libraries out there with the goal to help developers easily create and use SQLite databases. 
Unfortunately developers still have to get bogged down in simple tasks like writing table deifinitions 
and SQL queries to interract with the database. SwiftyDB automatically handles everything you don't want to spend your time doing.

[![CI Status](http://img.shields.io/travis/Øyvind Grimnes/SwiftyDB.svg?style=flat)](https://travis-ci.org/Øyvind Grimnes/SwiftyDB)
[![Version](https://img.shields.io/cocoapods/v/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![License](https://img.shields.io/cocoapods/l/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)

### Features
- [x] Table generation
- [x] Store any valid SQLite type
- [x] Support for optional types
- [x] Simple parameter-based queries
- [x] Thread safe
- [ ] Complex queries
- [ ] Store nested objects

**Supported types**
- [x] `Int`
- [x] `Float`
- [x] `Double`
- [x] `Bool`
- [x] `NSNumber` / `NSNumber?`
- [x] `String` / `String?`
- [x] `NSString` / `NSString?`
- [x] `NSDate` / `NSDate?`
- [x] `NSData` / `NSData?`
- [ ] Objects implementing the `Storable` protocol
- [ ] Collections

## Usage
Let's use this simple `Dog` class as an example

```Swift
class Dog {
    var id: NSNumber?
    var name: String?
    var owner: String?
    var dateOfBirth: NSDate?
}
```

### Defining your classes

All objects must conform to the `Storeable` protocol.

```Swift
@objc public protocol Storable {
    optional static func primaryKeys() -> Set<String>
    optional static func ignoredProperties() -> Set<String>
}
```

#### Store and retrieve objects

```Swift
class Dog: NSObject, Storable {
    dynamic var id: NSNumber?
    dynamic var name: String?
    dynamic var owner: String?
    dynamic var dateOfBirth: NSDate?
}
```

> Using the `dynamic` keyword is not necessary, but it helps to make sure the datatype is valid. Only values representable in Objective-C can be stored in this version because objects' properties are dynamically assigned upon retrieval. This unfortunate dependency will be removed when I find a better way of dynamically assigning properties.

##### Primary keys
It is recommended you can implement the `primaryKeys()` method in the `Storable` protocol. 
This method should return a set of property names which uniquely identifies an object.

```Swift
class func primaryKeys() -> Set<String> {
  return ["id"]
}
```

##### Ignoring properties
If your class contains properties that you don't want in your database, you can implement the `ignoredProperties()` method in the `Storable` protocol.
This method should return a set of property names which will be ignored.

```Swift
class func ignoredProperties() -> Set<String> {
  return ["name"]
}
```

#### Store objects and retrieve data as dictionaries

If you of some reason cannot subclass NSObject, it is to my knowledge impossible to dynamically create objects and assign its properties. In that case, all you have to do is to make sure you object conforms to the `Storable` protocol. 

```Swift
class Dog: Storable {
    var id: NSNumber?
    var name: String?
    var owner: String?
    var dateOfBirth: NSDate?
}
```

### Use the database
No more custom methods for interacting  with the database. SwiftyDB handles everything automagically 🎩

```Swift
let database = SwiftyDB(name: "Test")
let dog = Dog(id: 1, 
              name: "Max", 
              owner: "Phil", 
              dateOfBirth: NSDate())
```
Add or update a record
```Swift
database.addObject(dog, update: true)
````

Retrieve records matching some optional parameters
```Swift
/* Returns a singe Dog object from the database */
database.getObjectForType(Dog.self)
database.getObjectForType(Dog.self, parameters: ["id": 1])

/* Returns an array of Dog objects from the database */
database.getObjectsForType(Dog.self)
database.getObjectsForType(Dog.self, parameters: ["id": 1])
````

Delete records matching some parameters
```Swift
database.deleteObjectsForType(Dog.self)
database.deleteObjectsForType(Dog.self, parameters: ["name": "Max"])
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
