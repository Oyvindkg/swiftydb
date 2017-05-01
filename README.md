
[![Swifty logo](https://github.com/Oyvindkg/swiftydb/blob/swiftydb-2.0-dev/resources/logo.png)](https://github.com/Oyvindkg/swiftydb/blob/swiftydb-2.0-dev/resources/logo.png)

<br>

A typesafe, pure Swift database offering effortless persistence of objects. It draws inspiration from brilliant libraries such as [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) and [QueryKit](https://github.com/QueryKit/QueryKit) to create a powerfull and easy-to-use database.

<br>

[![CI Status](https://img.shields.io/travis/Oyvindkg/swiftydb/master.svg?style=flat)](https://travis-ci.org/Oyvindkg/swiftydb)
[![Version](https://img.shields.io/cocoapods/v/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![License](https://img.shields.io/cocoapods/l/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Swift](https://img.shields.io/badge/swift-3-brightgreen.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)

## Content
[Features](#features)<br />
[Usage](#usage)<br />
&emsp; [Creating the database](#usingTheDatabase)<br />
&emsp;&emsp; [Retrieving objects](#retrievingObjects)<br />
&emsp;&emsp; [Storing objects](#storingObjects)<br />
&emsp;&emsp; [Deleting objects](#deletingObjects)<br />
&emsp; [Defining objects](#definingObjects)<br />
&emsp;&emsp; [Mappable](#mappingObjects)<br />
&emsp;&emsp; [Identifiable](#identifyingObjects)<br />
&emsp;&emsp; [Indexable](#indexingObjects)<br />
&emsp; [Migration](#migratingObjects)<br />
[Installation](#installation)<br />
[Limitations](#limitations)<br />
[Performance](#performance)<br />
[License](#license)

## <a name="features">Main features</a>
- [x] Type safe and developer friendly
- [x] Store nested objects
- [x] Store arrays, sets, and dictionaries
- [x] Asynchronous database access
- [x] Thread safe database operations
- [x] Create custom indices to improve query performance
- [x] Automated migration

## <a name="usage">Usage</a>

### <a name="usingTheDatabase">Creating the database</a>

The easiest way to open a database, is simply providing a name for the database.

```Swift
let database = Database(name: "Westeros")
```

For a more detailed configuration, create a new `Configuration` object, and initiate the database

```Swift
var configuration = Configuration(name: "Westeros")

configuration.directory = "~/some/dir"
configuration.mode      = .sandbox

let database = Database(configuration: configuration)
```

#### <a name="retrievingObjects">Retrieving objects</a>

In order to retrieve all objects of a type from the database, simply call the `get(..)` method with the requested object type as a parameter.
```swift
database.get(Stark.self).then { starks in
  /* Use the retreived starks */
}
```

##### Filtering results

Filtering results is really simple due to SwiftyDB's expressive and powerfull query language  
```Swift
let query = Query.get(Stark.self).where("name" == "Sansa" || "age" < 15)

database.get(using: query).then { starks in
  /* Use the retreived starks */
}
```
It is also possible to filter results based on their nested objects' identifier
```Swift
let lady  = Wolf(name: "Lady")
let ghost = Wolf(name: "Ghost")

let query = Query.get(Stark.self).where("wolf" == lady || "wolf" == ghost)

/* Using a storable object in filters is short hand for `<Storable>.<identifier>` */
database.get(using: query).then { starks in
  /* Use the retreived starks */
}
```

| Operator | Function                                |
|:--------:|:----------------------------------------|
|    ==    | X is equal Y                            |
|    !=    | X is not equal Y                        |
|    <     | X is less than Y                        |
|    >     | X is greater than Y                     |
|    <=    | X is less than or equal to Y            |
|    >=    | X is greater than or equal to Y         |
|    ≈≈    | X matches pattern Y                     |
|    !≈    | X does not match pattern Y              |
|          |                                         |
|    <<    | X is in Y if Y is an array              |
|    !<    | X is not in Y if Y is an array          |
|    <<    | X is the range of Y if Y is a range     |
|    !<    | X is not the range of Y if Y is a range |
|          |                                         |
|    !     | Negation of X                           |
|    &&    | Conjunction of X and Y                  |
|   \|\|   | Disjunction of X and Y                  |


##### Sorting results

Sorting the results is also possible by using the `sort(.., ascending: ..)` method.
```Swift
let query = Query.get(Stark.self).order(by: "name", ascending: true)
```

##### Limitig results

To improve the performance of your queries, SwiftyDB offers simple pagination using the `start(..)` and `max(..)` methods. `start(..)` specifies the index of the first included result element, and `max(..)` specifies the maximum number of elements to be retrieved.
```Swift
/* Retrieve 3 starks, skipping the first 2 results */
let query = Query.get(Stark.self).max(3).skip(2)
```

#### <a name="storingObjects">Storing objects</a>
```Swift
let arya = Stark(name: "Arya", age: 9)

database.add(arya).catch { error in 
  /* Handle any errors */
}
```

#### <a name="deletingObjects">Deleting objects</a>
```Swift
let query = Query.delete(Stark.self).where("name" == "Eddard")

database.delete(using: query).catch { error in
  /* Handle any errors */
}
```

### <a name="definingObjects">Defining objects</a>
Any object can be storable by implementing the `Storable` protocol as an extension. This protocol consists of the `Mappable` and `Identifiable` protocols. This section will show how to make the `Stark` class storable.

```Swift
struct Stark {
  var name: String
  var wolf: Wolf?
  var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age  = age
  }
}
```

#### <a name="mappingObjects">Mappable</a>
Because the dynamic aspects of the Swift language are limited to read operations, this protocol is used to instantiate new objects and populate them with data dynamically.

```Swift
extension Stark: Mappable {

  /** Create a new object */
  static func mappableObject() -> Mappable {
    return Stark(name: "", age: 0)
  }
  
  /** Used to read and write data to objects */
  mutating func map<M>(using mapper: M) where M : Mapper {
    name <- mapper["name"]
    age  <- mapper["age"]
    wolf <- mapper["wolf"]
  }
}
```

> Inheritance is supported by overriding `map(using: Mapper)` and `mappableObject()` in the subtype. Remember to call `super.mapping(map)`!

#### <a name="identifyingObjects">Identifiable</a>
This protocol is used to identify unique objects in the database. This is necessary for the database to keep track of the individual objects and their references. 

`identifier()` should return the name of a property that uniquely identifies an object.

```Swift
extension Stark: Identifiable {
  
  static func identifier() -> String {
    return "name"
  }
}
```

#### <a name="indexingObjects">Indexable (optional)</a>

Creating an index on frequently queried properties can greatly improve retrieval performance. Create an index by providing a collection of properties to be indexed, and an optional filter used to limit the index domain.

```Swift
extension Stark: Indexable {
  static func indices() -> [AnyIndex] {
    return [
      Index.on("age"),
      Index.on("wolf", "name").where("name" << ["Arya", "Sansa"])
    ]
  }
}
```


### <a name="migratingObjects">Migration</a>

If the database detects that a type does not match the stored data, it will automatically add and remove properties in the database as necessary to reflect the type at all times.

> When changing your models, use `.sandbox` mode in the database `Configuration` to avoid undesired changes in the database. Change it back to `.normal` when you are certain everything is in order. 

## <a name="limitations">Limitations</a>
These are some known limitations of the current version:

- Cannot handle circular references between objects
- It is not possible to query collection properties
- It is not possible to store dictionaries of `Storable` objects

All limitations are ment to be improved as fast as possible. Feel free to contribute 😬

## <a name="performance">Performance</a>

Swifty is created for convenience, not speed. For most applications the performance is more than good enough, but is you are going to add and retrieve thousands of nested objects on a regular basis, this library probably isn't for you. 

Objects with various properties added and retrieved per second

| Hardware | Add with simple properties  | Get with simple properties | Add with collection properties  | Get with collection properties | Add with a nested object | Get with a nested object |
|:---:|:---|:---|:---|:---|:---|:---|
| iPhone 6 | 2500 | 3000 | 1000 | 1000 | 1200 | 1200 |

The performance will be improved in future updates. Until release, the focus will be on functionality

## <a name="installation">Installation</a>

### CocoaPods

SwiftyDB is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyDB", "~>2.0"
```

### Carthage
Add this line to your Cartfile
```
github 'Oyvindkg/swiftydb'
```

## Author

Øyvind Grimnes, oyvindkg@yahoo.com

## <a name="License">License</a>

SwiftyDB is available under the MIT license. See the LICENSE file for more info.
