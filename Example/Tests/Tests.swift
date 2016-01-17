// https://github.com/Quick/Quick

import Quick

class SwiftyDBSpec: QuickSpec {
    override func spec() {
        let documentsDir : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let path = documentsDir+"/test_database.sqlite"
        let _ = try? NSFileManager.defaultManager().removeItemAtPath(path)
        
//        let database = SwiftyDB(databaseName: "test_database")
//        database.addObject(TestClass())
//        print(database.dataForType(TestClass.self, matchingFilters: Filter.lessThan("primaryKey", value: 0)).value)

        
    }
}
