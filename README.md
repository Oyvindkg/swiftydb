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
- [x] Simple queries
- [x] Thread safe
- [ ] Advanced queries
- [ ] Store nested objects
- [ ] No dependencies
- [ ] Nonblocking reads

**Supported types**
- [x] `Int`
- [x] `Float`
- [x] `Double`
- [x] `Bool`
- [x] `NSNumber` / `NSNumber?`
- [x] `String` / `String?`
- [x] `NSDate` / `NSDate?`
- [x] `NSData` / `NSData?`
- [ ] Objects implementing the `Storable` protocol
- [ ] Collections

<!---
 ### Usecase
 Imagine you are working on a sizeable project, and need a local database to store objects like your Dog class. 
 ```Swift
 class Dog {
 var id: NSNumber?
 var name: String?
 var owner: String?
 var dateOfBirth: NSDate?
 }
 ```
 You have decided to use an SQLite database, and have added a library, e.g. the brilliant FMDB library, 
 helping you avoid the grittyest parts of the SQLite implementation. 
 Now you only need a simple method with a small SQL snippet, and the table is created.
 
 ```Swift
 func createDogTable() {
 let statement = "CREATE TABLE Dog (id INT, name TEXT, owner TEXT, dateOfBirth REAL)"
 Database().executeStatement(statement)
 }
 ```
 
 Only adding the table to your database isn't muc help. Of course, you need to be able to add data, so you create a function with custom SQL to handle this.
 
 ```Swift
 func updateDog(parameters: AnyObject) {
 let statement = "INSERT INTO Dog(id, name, owner, dateOfBirth) VALUES(?, ?, ?, ?)"
 Database().executeUpdate(statement, parameters: parameters)
 }
 ```
 
 If you want to update a record in the Dog table, you just have to create a small method passing an SQL statement and parameters to your SQLite library. 
 
 ```Swift
 func updateDog(parameters: AnyObject) {
 let statement = "UPDATE Dog SET name = ? AND owner = ? AND dateOfBirth = ? WHERE id = ?"
 Database().executeUpdate(statement, parameters: parameters)
 }
 ```
 
 Then you need to delete records too, and create yet another function
 
 ```Swift
 func deleteDog(parameters: AnyObject) {
 let statement = "DELETE FROM Dog WHERE id = ?"
 Database().executeUpdate(statement, parameters: parameters)
 }
 ```
 
 You realize that this was merely a single class of all the classes you want to be able to store. 
 You pull out your hair, and dream about a small library that could help you avoid all this boring, time consuming, and unnecessary work. 
 This is where SwiftyDB gives you a big, comforting hug.
 -->

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
All you have to do, is to make sure the class conforms to the `Storable` protocol. This is easily achieved by subclassing `NSObject`. 
SwiftyDB will automatically handle all the boring stuff behind like table creation behind the scenes.

> Using the `dynamic` keyword is not necessary, but it helps to make sure the datatype is valid. Only values representable in Objective-C can be stored in this version because objects' properties are dynamically assigned upon retrieval.

```Swift
class Dog: NSObject, Storable {
  dynamic var id: NSNumber?
  dynamic var name: String?
  dynamic var owner: String?
  dynamic var dateOfBirth: NSDate?

  override required init() {
    super.init()
  }
}
```

#### Primary keys
It is recommended you can implement the `primaryKeys()` method in the `Storable` protocol. 
This method should return a set of property names which uniquely identifies an object.

```Swift
class func primaryKeys() -> Set<String> {
  return ["id"]
}
```

#### Ignoring properties
If your class contains properties that you don't want in your database, you can implement the `ignoredProperties()` method in the `Storable` protocol.
This method should return a set of property names which will be ignored.

```Swift
class func ignoredProperties() -> Set<String> {
  return ["name"]
}
```

### Use the database
No more custom methods for interacting  with the database. SwiftyDB handles everything automagically 🎩

```Swift
let database = SwiftyDB(name: "Test")
let dog = Dog(id: 1, name: "Max", owner: "Phil", dateOfBirth: NSDate())
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

## Requirements
In this early version you must include the popular SQLite library FMDB in your project. This dependency will probably be removed at a later point. At least replaced by a more Swift friendly library.

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
