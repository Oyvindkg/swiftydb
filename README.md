# This is merely a placeholder at the moment :)

[![Swifty logo](https://s11.postimg.org/smlcw1akj/Swifty.png)](https://postimg.org/image/3tbsvdrjz/)

A typesafe, pure Swift database offering effortless persistence of objects. 

[![CI Status](https://img.shields.io/travis/Oyvindkg/swiftydb/master.svg?style=flat)](https://travis-ci.org/Oyvindkg/swiftydb)
[![Version](https://img.shields.io/cocoapods/v/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![License](https://img.shields.io/cocoapods/l/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDB.svg?style=flat)](http://cocoapods.org/pods/SwiftyDB)

## Content
[Features](#features)<br />
[Usage](#usage)<br />
&emsp; [Using the database](#usingTheDatabase)<br />
&emsp;&emsp; [Retrieving objects](#retrievingObjects)<br />
&emsp;&emsp;&emsp; [Filtering results](#filteringResults)<br />
&emsp;&emsp;&emsp; [Sorting results](#sortingResults)<br />
&emsp;&emsp;&emsp; [Limiting results](#limitingResults)<br />
&emsp;&emsp; [Storing objects](#storingObjects)<br />
&emsp;&emsp; [Deleting objects](#deletingObjects)<br />
&emsp; [Defining objects](#definingObjects)<br />
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
- [x] Migration
- [ ] Custom indices

## <a name="usage">Usage</a>

### <a name="usingTheDatabase">Access the database</a>
```Swift
let database = Swifty()
```
#### <a name="retrievingObjects">Retrieving objects</a>
```swift
let starks = database.get(Stark.self)
```
##### <a name="filteringResults">Filtering results</a>
```Swift
let filter = Filter().property("name", isEqualTo: "Sansa")
                     .property("age", isLessThan: 30)

let sansa = database.get(Stark.self, filter: filter).first
```

##### <a name="sortingResults">Sorting results</a>
```swift
let starks = database.get(Stark.self, sorting: .Ascending("age"))
```

##### <a name="limitingResults">Limiting results</a>
```Swift
let starks = database.get(Stark.self, limit: 10, offset: 2)
```

#### <a name="storingObjects">Storing objects</a>
```Swift
let arya = Stark(name: "Arya", age: 9)

database.add(arya)
```

#### <a name="deletingObjects">Deleting objects</a>
```Swift
let ned = Stark(name: "Eddard", age: 35)

database.remove(ned)
```

### <a name="definingObjects">Defining objects</a>
```Swift
class Stark {
  var name: String
  var wolf: Wolf?
  var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age  = age
  }
}
```

```Swift
class Stark: Storeable {
  var name: String
  var wolf: Wolf?
  var age: Int

  init(name: String, age: Int) {
    self.name = name
    self.age  = age
  }
  
  
  /* Storeable protocol methods */
  
  required init() {
    name = ""
    age  = 0
  }
  
  func mapping(map: Map) {
    name <- map["name"]
    age  <- map["age"]
    wolf <- map["wolf"]
  }
  
  static func identifier() -> String {
    return "name"
  }
}
```

## <a name="installation">Installation</a>

## <a name="limitations">Limitations</a>

## <a name="performance">Performance</a>



SwiftyDB is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyDB"
```

## Author

Øyvind Grimnes, oyvindkg@yahoo.com

## <a name="License">License</a>

SwiftyDB is available under the MIT license. See the LICENSE file for more info.
