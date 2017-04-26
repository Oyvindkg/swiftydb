[![CI Status](http://img.shields.io/travis/Øyvind Grimnes/TinySQLite.svg?style=flat)](https://travis-ci.org/Øyvind Grimnes/TinySQLite)
[![Version](https://img.shields.io/cocoapods/v/TinySQLite.svg?style=flat)](http://cocoapods.org/pods/TinySQLite)
[![License](https://img.shields.io/cocoapods/l/TinySQLite.svg?style=flat)](http://cocoapods.org/pods/TinySQLite)
[![Platform](https://img.shields.io/cocoapods/p/TinySQLite.svg?style=flat)](http://cocoapods.org/pods/TinySQLite)
[![Swift](https://img.shields.io/badge/swift-3-brightgreen.svg?style=flat)](http://cocoapods.org/pods/TinySQLite)

![alt text] (http://i.imgur.com/KvtukKk.png "Logo")

A lightweight SQLite wrapper written in Swift

###Features
- [x] Lightweight
- [x] Object oriented
- [x] Automatic parameter binding
- [x] Named parameter binding
- [x] Thread safe
- [x] Supports all native Swift types

## Usage
### Creating the database object
Provide the `DatabaseQueue` with a file URL. If the database file exists, the existing database file will be used. If not, a new database will be created automatically.
```Swift
let location = URL(fileURLWithPath: "path/to/database.sqlite")

let databaseQueue = DatabaseQueue(location: location)
```
### Creating queries
All valid SQLite queries are accepted by TinySQLite

To use automatic binding, replace the values in the statement by '?', and provide the values in an array

```Swift
let query = "INSERT INTO YourTable (column, otherColumn) VALUES (?, ?)"

let parameters = [1, "A value"]
```

To use automatic named binding, replace the values in the statement by ':\<name>', and provide the values in a dictionary

```Swift
let query = "INSERT INTO YourTable (column, otherColumn) VALUES (:column, :otherColumn)"

let parameterMapping = [
    "column": 1, 
    "otherColumn": "A value"
]
```

### Executing updates
Execute an update in the database
```Swift
try databaseQueue.database { (database) in
    let statement = try database.statement(for: query)
    
    statement.executeUpdate()
    statement.executeUpdate(withParameters: parameters)
    statement.executeUpdate(withParameterMapping: parameterMapping)
    
    statement.finalize()
}
```


### Executing queries
Execute a query to the database.
```Swift
try databaseQueue.database { (database) in
    let statement = try database.statement(for:query)
    
    try statement.execute()
    
    for row in statement {
    
        /* Get an integer from the second column in the row */
        row.integerForColumn(at: 2)
        
        /* Get a date from the column called 'deadline' */
        row.dateForColumn("deadline") 
        
        /* Get a dictionary representing the row */
        row.dictionary 
    }
    
    statement.finalize()
}
```

### Transactions
To improve performance, and prevent partial updates when executing multiple queries, you can use `DatabaseQueue`'s `transaction` method.
If an error is thrown in the block, all changes are rolled back. 
```Swift
try databaseQueue.transaction { (database) in
    try database.statement(for: query)
                .executeUpdate(withParameters: someParameters)
                .executeUpdate(withParameters: someOtherParameters)
                .executeUpdate(withParameters: evenMoreParameters)
                .finalize()
}
```

## Installation

### Cocoapods
TinySQLite is available through [CocoaPods](http://cocoapods.org). To install, simply add the following line to your Podfile:

```ruby
pod "TinySQLite", "0.4.2"
```

### Carthage
TinySQLite is available through [Carthage](https://github.com/Carthage/Carthage). To install, simply add the following line to your Cartfile:

```ruby
github "Oyvindkg/tinysqlite" "0.4.2"
```

## Author

Øyvind Grimnes, oyvindkg@yahoo.com

## License

TinySQLite is available under the MIT license. See the _LICENSE_ file for more info.
