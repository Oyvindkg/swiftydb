
[![Swifty logo](https://github.com/Oyvindkg/swiftydb/blob/swiftydb-2.0-dev/resources/logo.png)](https://github.com/Oyvindkg/swiftydb/blob/swiftydb-2.0-dev/resources/logo.png)

<br>

A typesafe, pure Swift database offering effortless persistence of objects. 

<br>

[![CI Status](https://img.shields.io/travis/Oyvindkg/swiftydb/master.svg?style=flat)](https://travis-ci.org/Oyvindkg/swiftydb)
[![Version](https://img.shields.io/cocoapods/v/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![License](https://img.shields.io/cocoapods/l/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)

## Content
[Features](#features)<br />
[Usage](#usage)<br />
&emsp; [Using the database](#usingTheDatabase)<br />
&emsp;&emsp; [Retrieving objects](#retrievingObjects)<br />
&emsp;&emsp; [Storing objects](#storingObjects)<br />
&emsp;&emsp; [Deleting objects](#deletingObjects)<br />
&emsp; [Defining objects](#definingObjects)<br />
&emsp; [Migration](#migratingObjects)<br />
&emsp; [Indexing](#indexingObjects)<br />
[Installation](#installation)<br />
[Limitations](#limitations)<br />
[Performance](#performance)<br />
[License](#license)

## <a name="features">Features</a>
- [x] Complex filtering
- [x] Supports all property types
- [x] Can store nested objects
- [x] Collections of objects or values
- [x] Thread safe database operations
- [x] Asynchronous database access
- [x] Custom indices
- [x] Migration

## <a name="usage">Usage</a>

### <a name="usingTheDatabase">Access the database</a>
```Swift
let swifty = Swifty()
```
#### <a name="retrievingObjects">Retrieving objects</a>
In order to retrieve all objects of a type from the database, simply call the `get(..)` method with the requested object type as a parameter.
```swift
swifty.get(Stark.self) { result in
  let starks = result.value
}
```

##### Filtering results

Filtering results is really simple due to SwiftyDB's expressive and powerfull query language  
```Swift
swifty.get(Stark.self).filter("name" << ["Sansa", "Arya", "Brandon"]) { result in
  let livingStarks = result.value
}
```
It is also possible to filter results based on their nested objects' identifier
```Swift
let lady  = Wolf(name: "Lady")
let ghost = Wolf(name: "Ghost")

/* `"wolf" == lady` is short hand for `"wolf" == lady.name` */
swifty.get(Stark.self).filter("wolf" == lady || "wolf" == ghost) { result in
  let sansa = result.value
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
|    ~=    | X matches pattern Y                     |
|    !~    | X does not match pattern Y              |
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
swifty.get(Stark.self).sort("name") { result in
  let starks = result.value
}
```

##### Limitig results

To improve the performance of your queries, SwiftyDB offers simple pagination using the `start(..)` and `max(..)` methods. `start(..)` specifies the index of the first included result element, and `max(..)` specifies the maximum number of elements to be retrieved.
```Swift
/* Retrieve 4 starks, ignoring the 2 first results */
swifty.get(Stark.self).start(2).max(4) { result in
  let starks = result.value
}
```

#### <a name="storingObjects">Storing objects</a>
```Swift
let arya = Stark(name: "Arya", age: 9)

swifty.add(arya) { result in 
  if errorMessage = result.errorMessage {
    // Handle errors
  }
}
```

#### <a name="deletingObjects">Deleting objects</a>
```Swift
swifty.delete(Stark.self).filter("name" == "Eddard")
```

### <a name="definingObjects">Defining objects</a>
Any object can be storable by implementing the `Storable` protocol as an extension. This protocol consists of the `Mappable` and `Identifiable` protocols. 

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
#### Mappable
Because the dynamic aspects of the Swift language are limited to read operations, this protocol is used to instantiate new objects and populate them with data dynamically.

```Swift
extension Stark: Mappable {
  static func newInstance() -> Mappable {
    return Stark(name: "", age: 0)
  }
    
  func mapping(map: Map) {
    name <- map["name"]
    age  <- map["age"]
    wolf <- map["wolf"]
  }
}
```

> Inheritance is supported by overriding `mapping(map: Map)` and `newInstance()` in the subtype. Remember to call `super.mapping(map)`

#### Identifiable
This protocol is used to identify unique objects in the database. This is necessary for the database to keep track of the individual objects and their references. 

`identifier()` should return the name of a property that uniquely identifies an object.

```Swift
extension Stark: Identifiable {
  static func identifier() -> String {
    return "name"
  }
}
```

> If an object identifier is `nil` when adding it to the database, an identifier will be generated automatically...


### <a name="migratingObjects">Migration</a>

Unrecognized property names are treated as new properties unless a renaming has been defined in the migration function. New properties are automtically added to the database. Removed properties are automatically removed....

```swift
extension Stark: Migratable {
  static func migrate(migration: MigrationType) {

    if migration.currentVersion < 2 {
  
      /* Add a new property */
      migration.add("height")
      
      /* Remove an existing property */
      migration.remove("age")
      
      /* Rename an existing property */
      migration.migrate("name").rename("firstName")
      
      /* Change the type of an exsisting property from `Double` to `Float` */
      migration.migrate("weight").transform(Double.self) { doubleValue in
        return Float(doubleValue!)
      }
    
      /* Both rename and change the type of an existing property */
      migration.migrate("name").rename("firstName").transform(String.self) { stringValue in
        return Double(stringValue ?? "")
      }
    }
  }
}
```

> Automatically detecting added and removed properties can be enabled in the database configuration, but is not encouraged. Manually defining these changes will help avoid migration errors, and make versioning easier for developers.

### <a name="indexingObjects">Indexing</a>

Creating an index on frequently queried properties can greatly increase thequery performance. Indexing a porperty, or collection of properties, can improve filtering and ordering of results.

```Swift
extension Stark: Indexable {
  static func index(index: IndexType) {
    index.on("age")
    index.on("age").filter("name" << ["Arya", "Sansa"] && "age" > 8)
  }
}
```

## <a name="limitations">Limitations</a>
These are some known limitations of the current version:

- Cannot handle circular references between objects
- It is not possible to query collections of values of objects

All limitations are ment to be improved as fast as possible. Feel free to contribute 😬

## <a name="performance">Performance</a>

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
