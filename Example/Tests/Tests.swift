// https://github.com/Quick/Quick

import Quick

class SwiftyDBSpec: QuickSpec {
    override func spec() {        
        let documentsDir : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let path = documentsDir+"/test_database.sqlite"
        let _ = try? NSFileManager.defaultManager().removeItemAtPath(path)
    }
}
